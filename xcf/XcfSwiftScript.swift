//
//  XcodeSwiftScript.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

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
        if let currentFolder {
            if let path = projectPath, path.contains(currentFolder) {
                return path
            }
            return nil
        }
        
        return projectPath
    }
}
