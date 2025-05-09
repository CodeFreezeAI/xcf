//
//  XcfActionHandler.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation

/// A class responsible for handling all XCodeFreeze (xcf) commands and actions.
/// This actor-isolated struct provides methods for project management, building,
/// running, and utility functions to interact with Xcode projects.
@MainActor
struct XcfActionHandler {
    static var XcfScript = XcfSwiftScript.shared
    // MARK: - Action Handling
    
    /// Main entry point for handling xcf actions from the command line
    /// - Parameter action: The string command to process (e.g., "build", "run", "list")
    /// - Returns: A formatted string response to the action request
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
            
        // Show projects (formerly list)
        case let cmd where cmd.starts(with: Actions.show):
            return listProjects()
        // Open project (formerly select)
        case let cmd where cmd.starts(with: Actions.open):
            // Check if we have a workspace folder restriction
            if let currentFolder {
                // Parse the project number from the command
                if let projectNumber = parseProjectNumber(from: action) {
                    // Get the list of projects
                    let xcArray = getSortedXcodeProjects()
                    
                    // Only apply security check if user is trying to select a specific project by number
                    if (1...xcArray.count).contains(projectNumber) {
                        let requestedProject = xcArray[projectNumber - 1]
                        
                        // Check if the requested project is within the workspace folder
                        if isProjectInWorkspaceFolder(projectPath: requestedProject, workspaceFolder: currentFolder) {
                            // If it's a valid selection within the workspace, allow it
                            currentProject = requestedProject
                            return String(format: SuccessMessages.currentProject, requestedProject)
                        } else {
                            // Security prevention - only override if user tried to select outside workspace
                            let safeProject = await findSafeProjectInWorkspace(workspaceFolder: currentFolder)
                            return String(format: SuccessMessages.securityPreventManualSelection, currentFolder, safeProject)
                        }
                    }
                }
            }
            
            // Default case - just run the normal selection logic
            return await selectProject(action: action)
        default:
            // No recognized action
            return String(format: ErrorMessages.unrecognizedAction, action)
        }
    }
    
    // MARK: - Public Methods
    
    /// Retrieves the currently selected project
    /// - Returns: The path to the current project, or nil if no project is selected
    public static func getCurrentProject() -> String? {
        return currentProject
    }
    
    /// Gets a sorted list of open Xcode projects
    /// - Parameter ext: The file extension to look for (defaults to .xc)
    /// - Returns: An array of paths to open Xcode projects, sorted alphabetically
    public static func getSortedXcodeProjects(ext: String = Format.xcodeFileExtension) -> [String] {
        return XcfScript.getXcodeDocumentPaths(ext: ext)
    }
    
    // MARK: - Project Selection
    
    /// Checks if a project file exists at the specified folder path
    /// - Parameter folderPath: The folder path to check for project files
    /// - Returns: A success message if a project file is found and selected, nil otherwise
    private static func checkAndSelectProjectFile(at folderPath: String) -> String? {
        let folderURL = URL(fileURLWithPath: folderPath)
        let folderName = folderURL.lastPathComponent
        let extensions = [".xcworkspace", ".xcodeproj"]
        
        for ext in extensions {
            let possiblePath = folderURL.appendingPathComponent("\(folderName)\(ext)").path
            if FileManager.default.fileExists(atPath: possiblePath) {
                currentProject = possiblePath
                return String(format: SuccessMessages.currentProject, possiblePath)
            }
        }
        
        return nil
    }
    
    /// Selects a project based on various criteria
    /// - Parameter action: Optional action string containing a project number to select
    /// - Returns: A message indicating the result of the selection process
    static func selectProject(action: String? = nil) async -> String {
        // Get the list of projects
        let xcArray = getSortedXcodeProjects()
        
        // Check for a match with the current folder
        if let cf = currentFolder {
            // First check if any open project contains the current folder
            for xc in xcArray {
                if xc.contains(cf) {
                    currentProject = xc
                    return String(format: SuccessMessages.currentProject, xc)
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
        return String(format: SuccessMessages.currentProject, currentProject ?? "")
    }
    
    /// Parses a project number from an action string
    /// - Parameter action: The action string to parse (format: "open N")
    /// - Returns: The parsed project number, or nil if the format is invalid
    private static func parseProjectNumber(from action: String) -> Int? {
        let parts = action.split(separator: Format.spaceSeparator)
        guard parts.count >= 2, let n = Int(parts[1]) else { return nil }
        return n
    }
    
    // MARK: - Project Operations
    
    /// Runs the current project
    /// - Returns: A message indicating the result of the run operation
    private static func runProject() async -> String {
        guard let currentProject else { return ErrorMessages.noProjectSelected }
        let buildCheckForErrors = XcfScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        
        if buildCheckForErrors.contains(SuccessMessages.success) {
            return XcfScript.buildCurrentWorkspace(projectPath: currentProject, run: true)
        } else {
            return buildCheckForErrors
        }
    }
    
    /// Builds the current project
    /// - Returns: A message indicating the result of the build operation
    private static func buildProject() async -> String {
        guard let currentProject else { return ErrorMessages.noProjectSelected }
        return XcfScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
    }
    
    // MARK: - Utility Methods
    
    /// Gets help information about available commands
    /// - Returns: A formatted string containing help information
    private static func getHelpText() -> String {
        return McpConfig.helpText
    }
    
    /// Grants permission to use Xcode automation
    /// - Returns: A message indicating the result of the permission operation
    private static func grantPermission() -> String {
        // May not be needed anymore... leave for now.
        let script = grantAutomation()
        return executeWithOsascript(script: script)
    }
    
    /// Lists all open Xcode projects
    /// - Returns: A formatted string containing a list of open projects
    private static func listProjects() -> String {
        let xcArray = getSortedXcodeProjects()

        if xcArray.isEmpty {
            return ErrorMessages.noOpenProjects
        }
        
        return getOpenProjectsList(projs: xcArray)
    }
    
    /// Formats a list of open projects
    /// - Parameter projs: Array of project paths to format
    /// - Returns: A formatted string listing projects with numbers
    private static func getOpenProjectsList(projs: [String]) -> String {
        var result = ""
        
        for (index, proj) in projs.enumerated() {
            result += String(format: Format.projectListFormat, index + 1, proj)
        }
        
        return result
    }
    
    /// Displays information about the current project
    /// - Returns: A formatted string showing the current project
    private static func showCurrentProject() -> String {
        guard let currentProject = getCurrentProject() else {
            return ErrorMessages.noProjectSelected
        }
        return "Current project: " + String(format: SuccessMessages.currentProject, currentProject)
    }
    
    /// Displays all environment variables
    /// - Returns: A formatted string showing all environment variables
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
    
    /// Checks if a project path is within the specified workspace folder
    /// - Parameters:
    ///   - projectPath: The path to the project
    ///   - workspaceFolder: The workspace folder path
    /// - Returns: True if the project is within the workspace folder
    private static func isProjectInWorkspaceFolder(projectPath: String, workspaceFolder: String) -> Bool {
        // Convert to URL to properly handle path comparisons
        let projectURL = URL(fileURLWithPath: projectPath)
        let workspaceFolderURL = URL(fileURLWithPath: workspaceFolder)
        
        // Check if the project path contains the workspace folder path
        return projectURL.path.contains(workspaceFolderURL.path)
    }
    
    /// Finds a safe project within the workspace folder
    /// - Parameter workspaceFolder: The workspace folder to search in
    /// - Returns: A safe project path within the workspace, or a message if none found
    private static func findSafeProjectInWorkspace(workspaceFolder: String) async -> String {
        // First try to find a match from existing open projects
        let projects = getSortedXcodeProjects()
        for project in projects {
            if isProjectInWorkspaceFolder(projectPath: project, workspaceFolder: workspaceFolder) {
                currentProject = project
                return String(format: SuccessMessages.currentProject, project)
            }
        }
        
        // If no match found, check for project files in the workspace folder
        if let result = checkAndSelectProjectFile(at: workspaceFolder) {
            return result
        }
        
        // No suitable project found
        return "I couldn't find a project in your workspace. Open an Xcode project in this folder."
    }
} 
