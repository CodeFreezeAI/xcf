//
//  Current.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

// Renamed global variables with clear prefix
var XcfXcodeProject: String? = ProcessInfo.processInfo.environment["XCODE_PROJECT"] ?? XcfSwiftScript.shared.activeWorkspacePath()
var XcfXcodeFolder: String? = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] ?? ProcessInfo.processInfo.environment["XCODE_PROJECT_FOLDER"] ?? ProcessInfo.processInfo.environment["XCODE_PROJECT_PATH"]

/// Centralized manager for Xcode project and folder paths
class XcfXcodeProjectManager {
    // Singleton instance
    static let shared = XcfXcodeProjectManager()
    
    private init() {}
    
    /// Get the current Xcode project path
    var currentProject: String? {
        get { return XcfXcodeProject }
        set { XcfXcodeProject = newValue }
    }
    
    /// Get the current working folder path
    var currentFolder: String? {
        get { return XcfXcodeFolder }
        set { XcfXcodeFolder = newValue }
    }
    
    /// Update both project and folder paths based on project selection
    /// - Parameter projectPath: The path to the selected Xcode project
    func updateFromProjectSelection(_ projectPath: String) {
        // Validate path is an Xcode project or workspace
        guard projectPath.hasSuffix(".xcodeproj") || projectPath.hasSuffix(".xcworkspace") else {
            print("Warning: \(projectPath) is not a valid Xcode project or workspace path")
            return
        }
        
        currentProject = projectPath
        
        // Get the project folder by removing .xcodeproj or .xcworkspace suffix
        // This preserves the project name folder at the end
        let projectDir: String
        if projectPath.hasSuffix(".xcodeproj") {
            projectDir = String(projectPath.dropLast(".xcodeproj".count))
        } else {
            projectDir = String(projectPath.dropLast(".xcworkspace".count))
        }
        
        // Set currentFolder to the project dir
        currentFolder = projectDir
        
        // Change working directory
        do {
            try XcfFileManager.changeDirectory(to: currentFolder ?? "")
        } catch {
            print("Warning: Could not change directory to \(currentFolder ?? ""): \(error.localizedDescription)")
        }
    }
    
    /// Initializes the manager with values from environment variables
    func initialize() {
        // Initialize current project from environment variables
        if currentProject == nil {
            let potentialProject = ProcessInfo.processInfo.environment["XCODE_PROJECT"] ?? XcfSwiftScript.shared.activeWorkspacePath()
            
            // Validate the project path before setting it
            if let projectPath = potentialProject, 
               (projectPath.hasSuffix(".xcodeproj") || projectPath.hasSuffix(".xcworkspace")) {
                currentProject = projectPath
            }
        }
        
        // Initialize current folder from environment variables or derive it from current project
        if currentFolder == nil {
            if let folderPath = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] ?? 
                               ProcessInfo.processInfo.environment["XCODE_PROJECT_FOLDER"] ?? 
                               ProcessInfo.processInfo.environment["XCODE_PROJECT_PATH"] {
                currentFolder = folderPath
            } else if let projectPath = currentProject {
                // Get the project folder by removing .xcodeproj or .xcworkspace suffix
                // This preserves the project name folder at the end
                if projectPath.hasSuffix(".xcodeproj") {
                    currentFolder = String(projectPath.dropLast(".xcodeproj".count))
                } else if projectPath.hasSuffix(".xcworkspace") {
                    currentFolder = String(projectPath.dropLast(".xcworkspace".count))
                }
            }
        }
        
        // Change working directory if we have a valid folder
        if let folderPath = currentFolder {
            do {
                try XcfFileManager.changeDirectory(to: folderPath)
            } catch {
                print("Warning: Could not change directory to \(folderPath): \(error.localizedDescription)")
            }
        }
    }
    
    /// Check if the project is within the allowed workspace folder
    /// - Parameters:
    ///   - projectPath: The path to check
    ///   - workspaceFolder: The workspace folder to check against
    /// - Returns: True if the project is within the workspace folder
    func isProjectInWorkspaceFolder(projectPath: String, workspaceFolder: String) -> Bool {
        let projectURL = URL(fileURLWithPath: projectPath)
        let workspaceFolderURL = URL(fileURLWithPath: workspaceFolder)
        
        return projectURL.path.contains(workspaceFolderURL.path)
    }
}

// For backward compatibility
var currentProject: String? {
    get { return XcfXcodeProjectManager.shared.currentProject }
    set { XcfXcodeProjectManager.shared.currentProject = newValue }
}

var currentFolder: String? {
    get { return XcfXcodeProjectManager.shared.currentFolder }
    set { XcfXcodeProjectManager.shared.currentFolder = newValue }
}
