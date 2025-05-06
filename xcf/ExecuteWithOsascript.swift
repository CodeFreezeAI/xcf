//
//  RunOsaScript.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

func executeWithOsascript(script: String) -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: Paths.osascriptPath)
    
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
            return result.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return ErrorMessages.failedToConvertOutput
        }
    } catch {
        return String(format: ErrorMessages.failedToExecuteOsascript, "\(error)")
    }
}
