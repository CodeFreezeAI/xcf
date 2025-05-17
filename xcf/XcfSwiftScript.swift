//
//  XcodeSwiftScript.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import AppKit
import Foundation
import ScriptingBridge

class XcfSwiftScript {
    static let shared = XcfSwiftScript()
    private var files: Set<String> = []
    func buildCurrentWorkspace(projectPath: String, run: Bool = false) -> String {

        // Get Xcode application instance
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            return ErrorMessages.failedToConnectXcode
        }
        
        // Open the project
        let xcDoc = xcode.open?(projectPath as Any)
        
        // Run the document
        guard
            let currentWorkspace = xcDoc as? XcodeWorkspaceDocument
        else {
            return ErrorMessages.noWorkspaceFound
        }
        
        currentWorkspace.stop?()
        
        var buildResult: XcodeSchemeActionResult?
        
        if run {
            sleep(XcodeConstants.runDelayInterval) // time for last one to get killed
            
            Task {
                currentWorkspace.runWithCommandLineArguments?(nil, withEnvironmentVariables: nil)
            }
            
            return SuccessMessages.runSuccess
        } else {
            buildResult = currentWorkspace.build?()
            if buildResult == nil {
                return ErrorMessages.failedToStartBuild
            }
        }
        
        // Now we can safely use buildResult outside the if/else blocks
        guard let result = buildResult else {
            return ErrorMessages.failedToGetBuildResult
        }
            
        // Wait for build to complete
        while !(result.completed ?? false) {
            Thread.sleep(forTimeInterval: XcodeConstants.buildPollInterval)
        }
        
        var buildResults = ""
        
        files = [] // Reset files collection before processing

        // Handle build errors with the original approach
        if let buildErrors = result.buildErrors?() {
            processIssues(issues: buildErrors, issueType: XcodeConstants.errorIssueType, buildResults: &buildResults)
        }
        
        // Handle other issue types if they're available
        if let buildWarnings = result.buildWarnings?() {
            processIssues(issues: buildWarnings, issueType: XcodeConstants.warningIssueType, buildResults: &buildResults)
        }
        
        if let analyzerIssues = result.analyzerIssues?() {
            processIssues(issues: analyzerIssues, issueType: XcodeConstants.analyzerIssueType, buildResults: &buildResults)
        }
        
        if let testFailures = result.testFailures?() {
            processIssues(issues: testFailures, issueType: XcodeConstants.testFailureIssueType, buildResults: &buildResults)
        }
        
         // Send entire file(s) at the end, uses a set to avoid duplicates
        for file in files {
            buildResults += "\(XcodeConstants.filePrefix)\(file)\(XcodeConstants.fileSuffix)\(Format.newLine)"
            let (fileContent, language) = CaptureSnippet.getCodeSnippet(filePath: file, startLine: 1, endLine: Int.max, entireFile: true)
            buildResults += "\(XcodeConstants.codeBlockStart)\(language)\(Format.newLine)"
            buildResults += fileContent
            buildResults += "\(Format.newLine)\(XcodeConstants.codeBlockEnd)\(Format.newLine)"
        }

        // Return build results
        return buildResults.isEmpty ? SuccessMessages.buildSuccess : buildResults
    }
    
    // Helper function to process different types of build issues
    private func processIssues(issues: SBElementArray, issueType: String, buildResults: inout String) {
        for case let issue as XcodeBuildError in issues {
            if let issueMessage = issue.message {
                if let filePath = issue.filePath,
                   let startingColNum = issue.startingColumnNumber,
                   let startLine = issue.startingLineNumber,
                   let endLine = issue.endingLineNumber {
                    files.insert(filePath)
                    buildResults += String(format: XcodeConstants.issueFormat, 
                                         filePath, startLine, startingColNum, issueType, issueMessage) + Format.newLine
                    buildResults += formatCodeSnippet(filePath: filePath, startLine: startLine, endLine: endLine)
                } else {
                    buildResults += "[\(issueType)] \(issueMessage)\(Format.newLine)"
                }
            }
        }
    }
    
    // Helper function to format code snippets consistently
    private func formatCodeSnippet(filePath: String, startLine: Int, endLine: Int) -> String {
        let (snippet, language) = CaptureSnippet.getCodeSnippet(filePath: filePath, startLine: startLine, endLine: endLine)
        var formattedSnippet = "\(XcodeConstants.codeBlockStart)\(language)\(Format.newLine)"
        formattedSnippet += snippet
        formattedSnippet += "\(Format.newLine)\(XcodeConstants.codeBlockEnd)\(Format.newLine)"
        return formattedSnippet
    }
    
    /// Gets paths of all open Xcode documents whose name contains the specified extension
    /// - Parameter ext: The extension or substring to filter document names by
    /// - Returns: Array of document paths matching the criteria, or empty array if none found or error occurred
    func getXcodeDocumentPaths(ext: String) -> [String] {
        // Get Xcode application instance
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return []
        }
        
        // Get all documents
        guard let documents = xcode.documents?() else {
            return []
        }
        
        var paths: Set<String> = []
        
        // Iterate through all documents and filter by extension
        for case let document as XcodeDocument in documents {
            if let name = document.name, name.contains(ext), let path = document.path {
                paths.insert(path)
            }
        }
        
        return Array(paths).sorted()
    }

     // New method to get schemes
    func getSchemes() -> [String] {
        // Get Xcode application instance
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return []
        }
        
        // Get the active workspace document
        guard let activeWorkspace = xcode.activeWorkspaceDocument else {
            print("No active workspace document.")
            return []
        }
        
        // Retrieve the schemes
        if let schemes = activeWorkspace.schemes?() as? [XcodeScheme] {
            return schemes.compactMap { $0.name }
        } else {
            print("No schemes found.")
            return []
        }
    }
    
    func activeWorkspacePath() -> String? {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return nil
        }
        
        guard let activeWorkspace = xcode.activeWorkspaceDocument else {
            return nil
        }
        
        let projectPath = activeWorkspace.path
        
        // Only return the path if currentFolder exists and path contains currentFolder
        if let currentFolder = XcfXcodeProjectManager.shared.currentFolder {
            if let path = projectPath, path.contains(currentFolder) {
                return path
            }
            return nil
        }
        
        return projectPath
    }
    
    // MARK: - Swift Document Management
    
    /// Opens a Swift document in Xcode
    /// - Parameter filePath: The path to the Swift file to open
    /// - Returns: True if successful, false otherwise
    func openSwiftDocument(filePath: String) -> Bool {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Use FileFinder to resolve the path
        let (resolvedPath, warning) = FileFinder.resolveFilePath(filePath)
        
        // If there was a warning, print it
        if !warning.isEmpty {
            print(warning)
        }
        
        // Verify the file exists and is a Swift file
        if !resolvedPath.hasSuffix(".swift") || !FileManager.default.fileExists(atPath: resolvedPath) {
            print("File does not exist or is not a Swift file: \(resolvedPath)")
            return false
        }
        
        // Try to open the document
        if let _ = xcode.open?(resolvedPath as Any) {
            return true
        }
        
        return false
    }
    
    /// Creates a new Swift document with FileManager
    /// - Parameters:
    ///   - filePath: The path where the Swift file should be created
    ///   - content: Initial content of the Swift file (optional)
    /// - Returns: True if successful, false otherwise
    func createSwiftDocumentWithFileManager(filePath: String, content: String = "") -> Bool {
        do {
            try XcfFileManager.createSwiftDocument(filePath: filePath, content: content)
            return true
        } catch {
            print("Error creating file: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Creates a new Swift document using Xcode ScriptingBridge
    /// - Parameters:
    ///   - filePath: The path where the Swift file should be created
    ///   - content: Initial content of the Swift file (optional)
    /// - Returns: True if successful, false otherwise
    func createSwiftDocumentWithScriptingBridge(filePath: String, content: String = "") -> Bool {
        // First create the file using FileManager
        if !createSwiftDocumentWithFileManager(filePath: filePath, content: content) {
            return false
        }
        
        // Then open it in Xcode
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Ensure the file path ends with .swift
        let path = filePath.hasSuffix(".swift") ? filePath : filePath + ".swift"
        
        // Open the document in Xcode
        if let _ = xcode.open?(path as Any) {
            return true
        }
        
        return false
    }
    
    // MARK: - Document Reading
    
    /// Reads the contents of a Swift document using FileManager
    /// - Parameter filePath: The path to the Swift file to read
    /// - Returns: The file contents as a string, or nil if the operation failed
    func readSwiftDocumentWithFileManager(filePath: String) -> String? {
        do {
            let (content, _) = try XcfFileManager.readFile(at: filePath)
            return content
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Reads the contents of a Swift document using Xcode ScriptingBridge
    /// - Parameter filePath: The path to the Swift file to read
    /// - Returns: The file contents as a string, or nil if the operation failed
    func readSwiftDocumentWithScriptingBridge(filePath: String) -> String? {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return nil
        }
        
        // Open the document in Xcode if it's not already open
        guard let document = xcode.open?(filePath as Any) as? XcodeSourceDocument else {
            print("Failed to open document in Xcode")
            return nil
        }
        
        // Return the document text
        return document.text
    }
    
    // MARK: - Document Writing
    
    /// Writes content to a Swift document using FileManager
    /// - Parameters:
    ///   - filePath: The path to the Swift file to write to
    ///   - content: The content to write to the file
    /// - Returns: True if successful, false otherwise
    func writeSwiftDocumentWithFileManager(filePath: String, content: String) -> Bool {
        do {
            try XcfFileManager.writeFile(content: content, to: filePath)
            return true
        } catch {
            print("Error writing to file: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Writes content to a Swift document using Xcode ScriptingBridge
    /// - Parameters:
    ///   - filePath: The path to the Swift file to write to
    ///   - content: The content to write to the file
    /// - Returns: True if successful, false otherwise
    func writeSwiftDocumentWithScriptingBridge(filePath: String, content: String) -> Bool {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Open the document in Xcode if it's not already open
        guard let document = xcode.open?(filePath as Any) as? XcodeSourceDocument else {
            print("Failed to open document in Xcode")
            return false
        }
        
        // Update the document text
        document.setText?(content)
        
        // Save the document (if needed)
        document.closeSaving?(.yes, savingIn: nil)
        
        return true
    }
    
    // MARK: - Document Editing
    
    /// Edits a Swift document by replacing text at specified range using FileManager
    /// - Parameters:
    ///   - filePath: The path to the Swift file to edit
    ///   - range: The range of text to replace (line and column based)
    ///   - replacement: The replacement text
    /// - Returns: True if successful, false otherwise
    func editSwiftDocumentWithFileManager(filePath: String, startLine: Int, endLine: Int, replacement: String) -> Bool {
        do {
            _ = try XcfFileManager.editSwiftDocument(filePath: filePath, startLine: startLine, endLine: endLine, replacement: replacement)
            return true
        } catch {
            print("Error editing file: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Edits a Swift document by replacing text at specified range using Xcode ScriptingBridge
    /// - Parameters:
    ///   - filePath: The path to the Swift file to edit
    ///   - startLine: The starting line to replace (1-indexed)
    ///   - endLine: The ending line to replace (1-indexed)
    ///   - replacement: The replacement text
    /// - Returns: True if successful, false otherwise
    func editSwiftDocumentWithScriptingBridge(filePath: String, startLine: Int, endLine: Int, replacement: String) -> Bool {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Open the document in Xcode if it's not already open
        guard let document = xcode.open?(filePath as Any) as? XcodeSourceDocument else {
            print("Failed to open document in Xcode")
            return false
        }
        
        // Get the content of the document
        guard let content = document.text else {
            print("Failed to get document text")
            return false
        }
        
        let lines = content.components(separatedBy: .newlines)
        
        // Validate line numbers
        guard startLine > 0, endLine > 0, startLine <= lines.count, endLine <= lines.count, startLine <= endLine else {
            print("Invalid line numbers. File has \(lines.count) lines.")
            return false
        }
        
        // Find the character range for the specified lines
        var startIndex = 0
        var endIndex = 0
        
        for i in 1..<startLine {
            startIndex += lines[i-1].count + 1 // +1 for newline
        }
        
        for i in 1...endLine {
            endIndex += lines[i-1].count
            if i < endLine {
                endIndex += 1 // +1 for newline except after the last line
            }
        }
        
        // Create a new string with the replacement
        let prefix = content.prefix(startIndex)
        let suffix = content.suffix(from: content.index(content.startIndex, offsetBy: endIndex))
        let newContent = prefix + replacement + suffix
        
        // Update the document text
        document.setText?(String(newContent))
        
        return true
    }
    
    // MARK: - Directory Operations
    
    /// Creates a directory at the specified path
    /// - Parameter directoryPath: The path where the directory should be created
    /// - Returns: True if successful, false otherwise
    func createDirectory(at directoryPath: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
            return true
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Lists files and directories at the specified path
    /// - Parameters:
    ///   - directoryPath: The path to list contents from
    ///   - extension: Optional file extension filter (e.g., "swift")
    /// - Returns: Array of file/directory paths, or empty array if operation failed
    func listDirectory(at directoryPath: String, extension fileExtension: String? = nil) -> [String] {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
            
            if let ext = fileExtension {
                return contents.filter { $0.hasSuffix(".\(ext)") }
                    .map { directoryPath + "/" + $0 }
            } else {
                return contents.map { directoryPath + "/" + $0 }
            }
        } catch {
            print("Error listing directory: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Shows a directory selection dialog and returns the selected path
    /// - Returns: The selected directory path, or nil if cancelled
    func selectDirectory() -> String? {
        return XcfFileManager.selectDirectory()
    }
    
    // MARK: - File Deletion
    
    /// Deletes a file using FileManager
    /// - Parameter filePath: The path to the file to delete
    /// - Returns: True if successful, false otherwise
    func deleteFileWithFileManager(at filePath: String) -> Bool {
        do {
            try XcfFileManager.deleteFile(at: filePath)
            return true
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Closes a Swift document in Xcode
    /// - Parameter filePath: The path to the Swift file to close
    /// - Returns: True if successful, false otherwise
    func closeSwiftDocument(filePath: String) -> Bool {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Find the document in Xcode
        guard let documents = xcode.documents?(),
              let document = (documents as? [XcodeDocument])?.first(where: { $0.path == filePath }) else {
            print("Document not found in Xcode: \(filePath)")
            return false
        }
        
        // Close the document
        document.closeSaving?(.no, savingIn: nil)
        return true
    }

    /// Deletes a file using ScriptingBridge
    /// - Parameter filePath: The path to the file to delete
    /// - Returns: True if successful, false otherwise
    func deleteFileWithScriptingBridge(at filePath: String) -> Bool {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // First close the document if it's open
        if let documents = xcode.documents?(),
           let document = (documents as? [XcodeDocument])?.first(where: { $0.path == filePath }) {
            document.closeSaving?(.no, savingIn: nil)
        }
        
        // Then delete the file using FileManager
        return deleteFileWithFileManager(at: filePath)
    }
}
