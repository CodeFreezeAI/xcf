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
        
        // Check build errors
        var files: Set<String> = []
        
        if let buildErrors = result.buildErrors?() {
            for case let error as XcodeBuildError in buildErrors {
                if let errorMessage = error.message {
                    if let filePath = error.filePath,
                       let startingColNum = error.startingColumnNumber,
                       let startLine = error.startingLineNumber,
                       let endLine = error.endingLineNumber {
                        files.insert(filePath)
                        buildResults += "\(filePath):\(endLine):\(startingColNum) \(errorMessage)\(Format.newLine)"
                        buildResults += "```swift\(Format.newLine)"
                        buildResults += captureSnippet(from: filePath, startLine: startLine, endLine: endLine, entireFile: false)
                        buildResults += "```\(Format.newLine)"
                    } else {
                        buildResults += "\(errorMessage)\(Format.newLine)"
                    }
                }
            }
            
            for file in files {
                buildResults += "Enter file `\(file)`:\(Format.newLine)"
                buildResults += "```swift\(Format.newLine)"
                buildResults += captureSnippet(from: file, startLine: 0, endLine: 0, entireFile: true)
                buildResults += "```\(Format.newLine)"
            }
        }
        
        return buildResults.isEmpty ? SuccessMessages.buildSuccess : buildResults
    }
   
}
