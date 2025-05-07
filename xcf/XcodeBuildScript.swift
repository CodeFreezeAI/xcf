//
//  XcodeBuildScript.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//


import Foundation
import ScriptingBridge

class XcodeBuildScript {
    func buildCurrentWorkspace(projectPath: String, run: Bool = false) -> String {
        // Get Xcode application instance
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: "com.apple.dt.Xcode") else {
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
            sleep(1) // time for last one to get killed
            
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
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        var buildResults = ""
        
        // Handle build errors with the original approach
        if let buildErrors = result.buildErrors?() {
            processIssues(issues: buildErrors, issueType: "Error", buildResults: &buildResults)
        }
        
        // Handle other issue types if they're available
        if let buildWarnings = result.buildWarnings?() {
            processIssues(issues: buildWarnings, issueType: "Warning", buildResults: &buildResults)
        }
        
        if let analyzerIssues = result.analyzerIssues?() {
            processIssues(issues: analyzerIssues, issueType: "Analyzer Issue", buildResults: &buildResults)
        }
        
        if let testFailures = result.testFailures?() {
            processIssues(issues: testFailures, issueType: "Test Failure", buildResults: &buildResults)
        }
        
        // Return build results
        return buildResults.isEmpty ? SuccessMessages.buildSuccess : buildResults
    }
    
    // Helper function to process different types of build issues
    private func processIssues(issues: SBElementArray, issueType: String, buildResults: inout String) {
        var files: Set<String> = []
        
        for case let issue as XcodeBuildError in issues {
            if let issueMessage = issue.message {
                if let filePath = issue.filePath,
                   let startingColNum = issue.startingColumnNumber,
                   let startLine = issue.startingLineNumber,
                   let endLine = issue.endingLineNumber {
                    files.insert(filePath)
                    buildResults += "\(filePath):\(startLine):\(startingColNum) [\(issueType)] \(issueMessage)\(Format.newLine)"
                    buildResults += "```swift\(Format.newLine)"
                    let (snippet, _) = CaptureSnippet.getCodeSnippet(filePath: filePath, startLine: startLine, endLine: endLine)
                    buildResults += snippet
                    buildResults += "```\(Format.newLine)"
                } else {
                    buildResults += "[\(issueType)] \(issueMessage)\(Format.newLine)"
                }
            }
        }
        
        // Send entire file at the end
        for file in files {
            buildResults += "File:`\(file)`:\(Format.newLine)"
            buildResults += "```swift\(Format.newLine)"
            let (fileContent, _) = CaptureSnippet.getCodeSnippet(filePath: file, startLine: 1, endLine: Int.max, entireFile: true)
            buildResults += fileContent
            buildResults += "```\(Format.newLine)"
        }
    }
   
}
