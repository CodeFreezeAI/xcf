//
//  XcfXcodeProjectManager.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

// Environment variable keys
private enum EnvKeys {
    static let xcodeProject = EnvVarKeys.xcodeProject
    static let workspaceFolderPaths = EnvVarKeys.workspaceFolderPaths
    static let xcodeProjectFolder = EnvVarKeys.xcodeProjectFolder
    static let xcodeProjectPath = EnvVarKeys.xcodeProjectPath
}

// File extensions
private enum FileExtensions {
    static let xcodeproj = Format.xcodeProjExtension
    static let xcworkspace = Format.xcodeWorkExtension
    
    static func isValidXcodeProjectPath(_ path: String) -> Bool {
        path.hasSuffix(xcodeproj) || path.hasSuffix(xcworkspace)
    }
    
    static func removeProjectSuffix(from path: String) -> String {
        if path.hasSuffix(xcodeproj) {
            return String(path.dropLast(xcodeproj.count))
        } else if path.hasSuffix(xcworkspace) {
            return String(path.dropLast(xcworkspace.count))
        }
        return path
    }
}

// Global variables with clear prefix for backward compatibility
private var XcfXcodeProject: String? = ProcessInfo.processInfo.environment[EnvKeys.xcodeProject] ?? XcfSwiftScript.shared.activeWorkspacePath()
private var XcfXcodeFolder: String? = {
    if let paths = ProcessInfo.processInfo.environment[EnvKeys.workspaceFolderPaths] {
        // Split by comma and take the first path
        let components = paths.components(separatedBy: Format.commaSeparator)
        return components.first?.trimmingCharacters(in: .whitespaces)
    }
    return ProcessInfo.processInfo.environment[EnvKeys.xcodeProjectFolder] ?? 
           ProcessInfo.processInfo.environment[EnvKeys.xcodeProjectPath]
}()

/// Centralized manager for Xcode project and folder paths
class XcfXcodeProjectManager {
    // Singleton instance
    static let shared = XcfXcodeProjectManager()
    
    private init() {}
    
    // MARK: - Properties
    
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
    
    // MARK: - Public Methods
    
    /// Update both project and folder paths based on project selection
    /// - Parameter projectPath: The path to the selected Xcode project
    func updateFromProjectSelection(_ projectPath: String) {
        guard FileExtensions.isValidXcodeProjectPath(projectPath) else {
            print(String(format: ErrorMessages.invalidProjectPath, projectPath))
            return
        }
        
        currentProject = projectPath
        currentFolder = FileExtensions.removeProjectSuffix(from: projectPath)
        
        updateWorkingDirectory()
    }
    
    /// Initializes the manager with values from environment variables
    func initialize() {
        initializeProject()
        initializeFolder()
        updateWorkingDirectory()
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
    
    // MARK: - Private Methods
    
    private func initializeProject() {
        if currentProject == nil {
            let potentialProject = ProcessInfo.processInfo.environment[EnvKeys.xcodeProject] ?? XcfSwiftScript.shared.activeWorkspacePath()
            
            if let projectPath = potentialProject,
               FileExtensions.isValidXcodeProjectPath(projectPath) {
                currentProject = projectPath
            }
        }
    }
    
    private func initializeFolder() {
        if currentFolder == nil {
            if let paths = ProcessInfo.processInfo.environment[EnvKeys.workspaceFolderPaths] {
                // Split by comma and take the first path
                let components = paths.components(separatedBy: Format.commaSeparator)
                currentFolder = components.first?.trimmingCharacters(in: .whitespaces)
            } else if let folderPath = ProcessInfo.processInfo.environment[EnvKeys.xcodeProjectFolder] ??
                                      ProcessInfo.processInfo.environment[EnvKeys.xcodeProjectPath] {
                currentFolder = folderPath
            } else if let projectPath = currentProject {
                currentFolder = FileExtensions.removeProjectSuffix(from: projectPath)
            }
        }
    }
    
    private func updateWorkingDirectory() {
        guard let folderPath = currentFolder else { return }
        
        do {
            try XcfFileManager.changeDirectory(to: folderPath)
        } catch {
            print(String(format: ErrorMessages.errorChangingDirectory, error.localizedDescription))
        }
    }
}

// For backward compatibility - consider deprecating in future versions
var currentProject: String? {
    get { return XcfXcodeProjectManager.shared.currentProject }
    set { XcfXcodeProjectManager.shared.currentProject = newValue }
}

var currentFolder: String? {
    get { return XcfXcodeProjectManager.shared.currentFolder }
    set { XcfXcodeProjectManager.shared.currentFolder = newValue }
}
