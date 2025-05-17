//
//  ExecuteWithOsascript.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

//MARK: Some Systems only approve over OSAScript - this is a workaround
//TODO: Monitor and see if we can switch the approval to ScriptingBridge
func grantAutomation() -> String {
    """
    tell application "Xcode"
        set xcDoc to first document
        
        tell xcDoc
            set buildResult to build
            
            repeat
                if completed of buildResult is true then
                    exit repeat
                end if
                delay 0.5
            end repeat
    
            return "Xcode Automation permission has been granted"
        end tell
    end tell
    """
}

func executeWithOsascript(script: String, timeout: TimeInterval = 30.0) -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: Paths.osascriptPath)
    
    // Create a pipe to capture the output
    let outputPipe = Pipe()
    let errorPipe = Pipe() // Add error pipe to capture stderr
    
    process.standardOutput = outputPipe
    process.standardError = errorPipe
    process.arguments = ["-e", script]
    
    do {
        try process.run()
        
        // Create a timeout
        let waitSemaphore = DispatchSemaphore(value: 0)
        let timeoutTask = DispatchWorkItem {
            if process.isRunning {
                process.terminate()
            }
        }
        
        // Schedule timeout
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout, execute: timeoutTask)
        
        // Wait in background
        DispatchQueue.global().async {
            process.waitUntilExit()
            timeoutTask.cancel() // Cancel timeout if process completes normally
            waitSemaphore.signal()
        }
        
        // Wait for completion or timeout
        let waitResult = waitSemaphore.wait(timeout: .now() + timeout + 1.0)
        if waitResult == .timedOut {
            return "Error: Process timed out after \(timeout) seconds"
        }
        
        // Check process exit status
        if process.terminationStatus != 0 {
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            if let errorString = String(data: errorData, encoding: .utf8), !errorString.isEmpty {
                return String(format: ErrorMessages.failedToExecuteOsascript, errorString)
            }
        }
        
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
