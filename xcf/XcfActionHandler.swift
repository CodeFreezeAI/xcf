//
//  XcfActionHandler.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation

@MainActor
struct XcfActionHandler {
    // Main entry point for handling actions
    static func handleAction(action: String) async -> String {
        // Convert action to lowercase for case-insensitive matching
        let lowercasedAction = action.lowercased()
       
        switch lowercasedAction {
        case Actions.useXcf:
            return SuccessMessages.xcfActive
        case Actions.help, Actions.xcf, Actions.xcf + Format.spaceSeparator + Actions.help:
            return getHelpText()
        case Actions.grant:
            return grantPermission()
        case Actions.run:
            return await runProject()
        case Actions.build:
            return await buildProject()
        case Actions.current:
            return showCurrentProject()
        case Actions.env:
            return showEnvironmentVariables()
            
        // List projects
        case let cmd where cmd.starts(with: Actions.list):
            return listProjects()
            
        // Select project
        case let cmd where cmd.starts(with: Actions.select):
            return selectProject(action: action)
            
        default:
            // No recognized action
            return String(format: ErrorMessages.unrecognizedAction, action)
        }
    }
    
    // NEW: Expose current project for status notifications
    public static func getCurrentProject() -> String? {
        return currentProject
    }
    
    // Get help information
    private static func getHelpText() -> String {
        return McpConfig.helpText
    }
    
    // Grant permission to use Xcode automation
    private static func grantPermission() -> String {
        // May not be needed anymore... leave for now.
        let script = grantAutomation()
        return executeWithOsascript(script: script)
    }
    
    // Run the current project
    private static func runProject() async -> String {
        guard let currentProject else { return ErrorMessages.noProjectSelected }
        let XcodeBuildScript = XcodeBuildScript()
        let buildCheckForErrors = XcodeBuildScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        
        if buildCheckForErrors.contains(SuccessMessages.success) {
            return XcodeBuildScript.buildCurrentWorkspace(projectPath: currentProject, run: true)
        } else {
            return buildCheckForErrors
        }
    }
    
    // Build the current project
    private static func buildProject() async -> String {
        guard let currentProject else { return ErrorMessages.noProjectSelected }
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: false)
    }
    
    // List all open Xcode projects
    private static func listProjects() -> String {
        let xcArray = getSortedXcodeProjects()

        if xcArray.isEmpty {
            return ErrorMessages.noOpenProjects
        }
        
        return getOpenProjectsList(projs: xcArray)
    }
    
    // Helper method to check and select project files
    private static func checkAndSelectProjectFile(at folderPath: String) -> String? {
        let folderURL = URL(fileURLWithPath: folderPath)
        let folderName = folderURL.lastPathComponent
        let extensions = [".xcworkspace", ".xcodeproj"]
        
        for ext in extensions {
            let possiblePath = folderURL.appendingPathComponent("\(folderName)\(ext)").path
            if FileManager.default.fileExists(atPath: possiblePath) {
                currentProject = possiblePath
                return String(format: SuccessMessages.projectSelected, 0, possiblePath)
            }
        }
        
        return nil
    }
    
    // Select a project by number
    static func selectProject(action: String? = nil) -> String {
        // Get the list of projects
        let xcArray = getSortedXcodeProjects()
        
        // Check for a match with the current folder
        if let cf = currentFolder {
            // First check if any open project contains the current folder
            for xc in xcArray {
                if xc.contains(cf) {
                    return(xc)
                }
            }
            
            // Then check for project files in the current folder
            if let result = checkAndSelectProjectFile(at: cf) {
                return result
            }
        }
        
        guard let action else {
            return ErrorMessages.invalidProjectSelection
        }
        
        // Parse the project number
        let projectNumber = parseProjectNumber(from: action)
        
        // Check if the project number is valid
        guard let projectNumber else {
            return ErrorMessages.invalidProjectSelection
        }
        
        // Check if there are any projects
        guard !xcArray.isEmpty else {
            return ErrorMessages.noOpenProjects
        }
        
        // Check if the project number is in range
        guard (1...xcArray.count).contains(projectNumber) else {
            return String(format: ErrorMessages.projectOutOfRange, "\(projectNumber)", "\(xcArray.count)")
        }
        
        // Select the project
        currentProject = xcArray[projectNumber - 1]
        return String(format: SuccessMessages.projectSelected, projectNumber, currentProject ?? "")
    }
    
    // Parse the project number from an action
    private static func parseProjectNumber(from action: String) -> Int? {
        let parts = action.split(separator: Format.spaceSeparator)
        guard parts.count >= 2, let n = Int(parts[1]) else { return nil }
        return n
    }
    
    // Get a sorted list of open Xcode projects
    public static func getSortedXcodeProjects(ext: String = Format.xcodeFileExtension) -> [String] {
        let xc = AppleScriptDescriptorToSet(script: getXcodeDocumentPaths(ext: ext))
        return Array(xc).sorted() // Convert Set to Array and sort alphabetically
    }
    
    // Get a formatted list of open projects
    private static func getOpenProjectsList(projs: [String]) -> String {
        var result = ""
        
        for (index, proj) in projs.enumerated() {
            result += String(format: Format.projectListFormat, index + 1, proj)
        }
        
        return result
    }
    
    // Display the current project
    private static func showCurrentProject() -> String {
        guard let currentProject = getCurrentProject() else {
            return ErrorMessages.noProjectSelected
        }
        return String(format: SuccessMessages.currentProject, currentProject)
    }
    
    // Display environment variables
    private static func showEnvironmentVariables() -> String {
        let environment = ProcessInfo.processInfo.environment
        var envString = ""
        
        // Sort keys for consistent output
        let sortedKeys = environment.keys.sorted()
        
        for key in sortedKeys {
            if let value = environment[key] {
                envString += "\(key): \(value)\n"
            }
        }
        
        return String(format: SuccessMessages.environmentVariables, envString)
    }
} 
