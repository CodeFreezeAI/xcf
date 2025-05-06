import Foundation
import ScriptingBridge

class XcodeBuildScript {
    func buildCurrentWorkspace(projectPath: String, run: Bool = false) -> String {
        // Get Xcode application instance
        guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: "com.apple.dt.Xcode") else {
            return "Failed to connect to Xcode"
        }
        
        // Open the project
        let xcDoc = xcode.open?(projectPath as Any)
        
        // Run the document
        guard
            let currentWorkspace = xcDoc as? XcodeWorkspaceDocument
        else {
            return "No workspace document found"
        }
        
        currentWorkspace.stop?()
        
        var buildResult: XcodeSchemeActionResult?
        
        if run {
            sleep(1) // time for last one to get killed
            
            Task {
                currentWorkspace.runWithCommandLineArguments?(nil, withEnvironmentVariables: nil)
            }
            
            return "🐦📜 Ran successfully"
        } else {
            buildResult = currentWorkspace.build?()
            if buildResult == nil {
                return "Failed to start build"
            }
        }
        
        // Now we can safely use buildResult outside the if/else blocks
        guard let result = buildResult else {
            return "Failed to get build result"
        }
            
        // Wait for build to complete
        while !(result.completed ?? false) {
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        var buildResults = ""
        
        // Check build errors
        if let buildErrors = result.buildErrors?() {
            for case let error as XcodeBuildError in buildErrors {
                if let errorMessage = error.message {
                    if let filePath = error.filePath {
                        let startingColNum = error.startingColumnNumber ?? 0
                        let lineNum = error.startingLineNumber ?? 0
                        buildResults += "\(filePath):\(lineNum):\(startingColNum) \(errorMessage)\n"} else {
                        buildResults += "\(errorMessage)\n"
                    }
                }
            }
        }
        
        return buildResults.isEmpty ? "🐦📜 Built successfully" : buildResults
    }
   
}
