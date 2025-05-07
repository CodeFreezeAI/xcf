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
    
    // Select a project by number
    private static func selectProject(action: String) -> String {
        // Parse the project number
        let projectNumber = parseProjectNumber(from: action)
        
        // Check if the project number is valid
        guard let projectNumber = projectNumber else {
            return ErrorMessages.invalidProjectSelection
        }
        
        // Get the list of projects
        let xcArray = getSortedXcodeProjects()
        
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
        persistSelectedProject(currentProject ?? "")
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

    // Add state management for project selection
    static func persistSelectedProject(_ projectPath: String) {
        let filePath = Paths.stateFilePath(for: projectPath)
        print("DEBUG: Saving state to \(filePath)")
        try? projectPath.write(toFile: filePath, atomically: true, encoding: .utf8)
        print("DEBUG: State file exists: \(FileManager.default.fileExists(atPath: filePath))")
    }

    static func getPersistedSelectedProject(for projectPath: String) -> String? {
        let filePath = Paths.stateFilePath(for: projectPath)
        print("DEBUG: Looking for state at \(filePath)")
        print("DEBUG: State file exists: \(FileManager.default.fileExists(atPath: filePath))")
        return try? String(contentsOfFile: filePath, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Call this on xcf startup or when switching projects
    static func loadState(for projectPath: String) -> String? {
        let result = getPersistedSelectedProject(for: projectPath)
        print("DEBUG: Loaded state for \(projectPath): \(result ?? "nil")")
        return result
    }
    
    // Automatically load state based on current working directory
    @MainActor
    static func autoLoadStateForCurrentDirectory() -> String? {
        let cwd = FileManager.default.currentDirectoryPath
        print("DEBUG: Current working directory: \(cwd)")
        let openProjects = getSortedXcodeProjects()
        print("DEBUG: Open projects: \(openProjects)")
        
        // Prefer a project that matches the CWD
        if let match = openProjects.first(where: { $0.hasPrefix(cwd) }) {
            print("DEBUG: Found matching project for CWD: \(match)")
            if let persisted = loadState(for: match), !persisted.isEmpty {
                currentProject = persisted
                print("DEBUG: Set current project to: \(persisted)")
                return persisted
            }
        }
        
        // Fallback: any open project with a state file
        for project in openProjects {
            if let persisted = loadState(for: project), !persisted.isEmpty {
                currentProject = persisted
                print("DEBUG: Set current project from fallback to: \(persisted)")
                return persisted
            }
        }
        
        print("DEBUG: No state found for any open project")
        return nil
    }
} 
