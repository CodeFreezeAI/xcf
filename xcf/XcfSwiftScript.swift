//
//  XcfSwiftScript.swift
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
        
        // Verify the file exists
        if !FileManager.default.fileExists(atPath: resolvedPath) {
            print("File does not exist or is not a Swift file: \(resolvedPath)")
            return false
        }
        
        // Try to open the document
        if let _ = xcode.open?(resolvedPath as Any) {
            return true
        }
        
        return false
    }
    
    /// Creates a new Swift document using Xcode ScriptingBridge
    /// - Parameters:
    ///   - filePath: The path where the Swift file should be created
    ///   - content: Initial content of the Swift file (optional)
    /// - Returns: True if successful, false otherwise
    func createSwiftDocumentWithScriptingBridge(filePath: String, content: String = "") -> Bool {
        guard let _: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Use FileFinder to resolve the path
        let (resolvedPath, warning) = FileFinder.resolveFilePath(filePath)
        
        // If there was a warning, print it
        if !warning.isEmpty {
            print(warning)
        }
        
        // First create the file using FileManager
        do {
            try XcfFileManager.writeFile(content: content, to: resolvedPath)
        } catch {
            return false
        }
        
        
        // Verify the file exists and is a Swift file
        if !FileManager.default.fileExists(atPath: resolvedPath) {
            print("File does not exist or is not a Swift file: \(resolvedPath)")
            //return false
        }
        
        // Try to open the document
        return openSwiftDocument(filePath: resolvedPath)
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
        
        // Save the document
        document.closeSaving?(.yes, savingIn: nil)
        
        // Reopen the document
        _ = xcode.open?(filePath as Any)
        
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
        
        // Use FuzzyLogicService to resolve the path
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        // If there was a warning, print it
        if !warning.isEmpty {
            print(warning)
        }
        
        print("Attempting to edit document at path: \(resolvedPath)")
        
        // Try to open the document in Xcode
        guard let document = xcode.open?(resolvedPath as Any) as? XcodeSourceDocument else {
            print("Failed to open document in Xcode: \(resolvedPath)")
            return false
        }
        
        // Get the current content of the document using Scripting Bridge
        guard let fullText = document.text else {
            print("Failed to get document text")
            return false
        }
        
        print("Successfully got document text, length: \(fullText.count)")
        
        // Split the text into lines
        let lines = fullText.components(separatedBy: .newlines)
        print("Document has \(lines.count) lines")
        
        // Check line range validity
        guard startLine >= 1, endLine >= startLine, endLine <= lines.count else {
            print("Invalid line range: \(startLine)-\(endLine). Document has \(lines.count) lines.")
            return false
        }
        
        // Create a new text with the replacement
        var newLines = [String]()
        
        // Add lines before the replacement
        for i in 0..<(startLine-1) {
            newLines.append(lines[i])
        }
        
        // Add the replacement lines
        let replacementLines = replacement.components(separatedBy: .newlines)
        newLines.append(contentsOf: replacementLines)
        
        // Add lines after the replacement
        if endLine < lines.count {
            for i in endLine..<lines.count {
                newLines.append(lines[i])
            }
        }
        
        // Join back into a single string
        let newText = newLines.joined(separator: "\n")
        print("Created new text, length: \(newText.count)")
        
        // Use Scripting Bridge to update the document
        document.setText?(newText)
        print("Document text has been updated")
        
        // Save file to disk by writing directly to the file
        do {
            try newText.write(toFile: resolvedPath, atomically: true, encoding: .utf8)
            print("Saved changes to disk: \(resolvedPath)")
        } catch {
            print("Error saving file to disk: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    // MARK: - Directory Operations
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
    func closeSwiftDocument(filePath: String, xcSaveOptions: XcodeSaveOptions ) -> Bool {
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: XcodeConstants.xcodeBundleIdentifier) else {
            print(ErrorMessages.failedToConnectXcode)
            return false
        }
        
        // Use FileFinder to resolve the path
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        // If there was a warning, print it
        if !warning.isEmpty {
            print(warning)
        }
        
        // Find the document in Xcode
        guard let documents = xcode.documents?() else {
            print("No documents open in Xcode")
            return false
        }
        
        // Debug information
        print("Looking for document with path: \(resolvedPath)")
        print("Number of open documents: \((documents as? [XcodeDocument])?.count ?? 0)")
        
        if let documentList = documents as? [XcodeDocument] {
            for doc in documentList {
                print("Document path: \(doc.path ?? "unknown")")
            }
        }
        
        // Try to find document with exact path
        if let document = (documents as? [XcodeDocument])?.first(where: { $0.path == resolvedPath }) {
            // Close the document
            document.closeSaving?(xcSaveOptions, savingIn: nil)
            return true
        }
        
        // Try to find document with filename match (more lenient)
        let filename = (resolvedPath as NSString).lastPathComponent
        if let document = (documents as? [XcodeDocument])?.first(where: {
            if let docPath = $0.path {
                return (docPath as NSString).lastPathComponent == filename
            }
            return false
        }) {
            // Close the document
            document.closeSaving?(xcSaveOptions, savingIn: nil)
            return true
        }
        
        print("Document not found in Xcode: \(resolvedPath)")
        return false
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
    
    /// Calculates the total number of lines in a document
    /// - Parameter filePath: Path to the file to count lines
    /// - Returns: Total number of lines in the document, or nil if the file cannot be read
    func calculateDocumentEndLine(filePath: String) -> Int? {
        do {
            let (content, _) = try XcfFileManager.readFile(at: filePath)
            let lines = content.components(separatedBy: .newlines)
            return lines.count
        } catch {
            print("Error calculating end line: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Searches a file for lines containing specific text
    /// - Parameters:
    ///   - filePath: Path to the file to search
    ///   - searchText: Text to search for in the file
    ///   - caseSensitive: Whether the search should be case-sensitive (default is false)
    /// - Returns: An array of line numbers where the text is found, or nil if the file cannot be read
    func searchLinesInDocument(filePath: String, searchText: String, caseSensitive: Bool = false) -> [Int]? {
        do {
            let (content, _) = try XcfFileManager.readFile(at: filePath)
            let lines = content.components(separatedBy: .newlines)
            
            var matchedLineNumbers: [Int] = []
            
            for (index, line) in lines.enumerated() {
                let lineToCheck = caseSensitive ? line : line.lowercased()
                let searchTextToCheck = caseSensitive ? searchText : searchText.lowercased()
                
                if lineToCheck.contains(searchTextToCheck) {
                    matchedLineNumbers.append(index + 1)  // Convert to 1-indexed line numbers
                }
            }
            
            return matchedLineNumbers
        } catch {
            print("Error searching lines: \(error.localizedDescription)")
            return nil
        }
    }
}
