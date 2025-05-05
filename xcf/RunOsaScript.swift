//
//  RunOsaScript.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

@discardableResult
func executeAppleScript(script: String) -> String {
    if let appleScript = NSAppleScript(source: script) {
        var errorDict: NSDictionary? = nil
        let output = appleScript.executeAndReturnError(&errorDict)
        
        if let error = errorDict {
            return "Error: \(error)"
        }
        return output.stringValue ?? "AppleScript executed successfully."
    } else {
        return "Failed to create AppleScript."
    }
}

func executeWithOsascript(script: String) -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    
    // Create a pipe to capture the output
    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    process.arguments = ["-e", script]
    
    do {
        try process.run()
        
        // Wait for the process to finish
        process.waitUntilExit()
        
        // Read the output data
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        
        // Convert the data to a string
        if let result = String(data: data, encoding: .utf8) {
            print(result)
            print("AppleScript executed via osascript.")
            return result.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            print("Failed to convert output data to string.")
            return ""
        }
    } catch {
        print("Failed to execute osascript: \(error)")
        return ""
    }
}

//private func validatePath() {
//    let fileManager = FileManager.default
//    isValidPath = fileManager.fileExists(atPath: projectPath) &&
//                 (projectPath.hasSuffix(".xcodeproj") || projectPath.hasSuffix(".xcworkspace"))
//}
