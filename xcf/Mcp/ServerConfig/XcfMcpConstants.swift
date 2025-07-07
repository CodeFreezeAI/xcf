//
//  XcfMcpStructStrings.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//
import Foundation

// Core app constants
struct AppConstants {
    static let appName = "xcf"
}

// Define string constants for commands
struct Actions {
    static let xcf = AppConstants.appName,
               help = "help",
               show = "show",
               open = "open",
               run = "run",
               build = "build",
               grant = "grant",
               current = "current",
               env = "env",
               pwd = "pwd",
               dir = "dir",
               path = "path",
               analyze = "analyze",
               lz = "lz" // Short alias for analyze
}

// Environment variable constants
struct EnvVarKeys {
    static let xcodeProject = "XCODE_PROJECT",
               workspaceFolderPaths = "WORKSPACE_FOLDER_PATHS",
               xcodeProjectFolder = "XCODE_PROJECT_FOLDER",
               xcodeProjectPath = "XCODE_PROJECT_PATH"
}

// Define error messages
struct ErrorMessages {
    // MARK: - Project Selection Errors
    static let noProjectSelected = "No project selected yet. Use 'show' to see available projects.",
               noOpenProjects = "I don't see any open Xcode projects. Try opening one first.",
               invalidProjectSelection = "That's not a valid selection. Try 'open 1' to select the first project.",
               projectOutOfRange = "Project %@ doesn't exist. I only found %@ projects.",
               noProjectInWorkspace = "I couldn't find a project in your workspace.",
               invalidProjectPath = "Warning: %@ is not a valid Xcode project or workspace path"
    
    // MARK: - Action Errors
    static let unrecognizedAction = "I don't understand '%@'. Try 'help' to see what I can do.",
               toolCallError = "Error executing tool '%@': %@"
    
    // MARK: - Xcode Connection Errors
    static let failedToConnectXcode = "I couldn't connect to Xcode. Is it running?",
               noWorkspaceFound = "I couldn't find a workspace document. Try opening an Xcode project first."
    
    // MARK: - Build Errors
    static let failedToStartBuild = "I had trouble starting the build. Please try again.",
               failedToGetBuildResult = "I couldn't get the build results. Something went wrong.",
               errorGettingBuildResults = "Error getting build results: %@"
    
    // MARK: - File Operation Errors
    static let errorReadingFile = "Error reading file: %@",
               errorWritingFile = "Error writing file: %@",
               errorCreatingFile = "Error creating file: %@",
               errorEditingFile = "Error editing file: %@",
               errorDeletingFile = "Error deleting file: %@",
               errorOpeningFile = "Error opening file: %@",
               errorClosingFile = "Error closing file: %@",
               errorReadingDirectory = "Error reading directory: %@",
               errorCreatingDirectory = "Error creating directory: %@",
               errorSelectingDirectory = "Error selecting directory: %@",
               errorListingProjects = "Error listing projects: %@",
               fileNotFound = "File not found: %@",
               directoryNotFound = "Directory not found: %@",
               invalidFilePath = "Invalid file path: %@",
               invalidDirectoryPath = "Invalid directory path: %@",
               fileAlreadyExists = "File already exists: %@",
               directoryAlreadyExists = "Directory already exists: %@",
               permissionDenied = "Permission denied: %@",
               unknownFileError = "Unknown error occurred while operating on: %@"
    
    // MARK: - Osascript Errors
    static let failedToConvertOutput = "Failed to convert output data to string.",
               failedToExecuteOsascript = "Failed to execute osascript: %@",
               failedToCreateAppleScript = "Failed to create AppleScript.",
               appleScriptError = "Error: %@"
    
    // MARK: - MCP Errors
    static let unknownTool = "Unknown tool: %@"
    
    // MARK: - Code Snippet Errors
    static let missingLineParamsError = "Missing required line parameters when entireFile is false",
               missingFilePathError = "Missing required filePath parameter",
               invalidLineNumbers = "Those line numbers don't look right. Please check them."
    
    // Resource error messages
    static let missingFilePathParamError = "Missing required filePath parameter for file operation",
               missingDirectoryPathParamError = "Missing required directoryPath parameter",
               unknownResourceUriError = "Unknown resource URI: %@",
               unknownPromptNameError = "Unknown prompt name: %@"
    
    // Directory operation errors
    static let errorChangingDirectory = "Error changing directory: %@",
               errorRemovingDirectory = "Error removing directory: %@"
    
    // Error message for creating a diff
    static let errorCreatingDiff = "Error creating diff: %@"
}

// Define success messages
struct SuccessMessages {
    static let xcfActive = "All \(AppConstants.appName) systems go!",
               buildSuccess = "🐦📜 Built successfully",
               runSuccess = "🐦📜 Ran successfully",
               permissionGranted = "Permission Granted",
               success = "success",
               pwdSuccess = "Current directory: %@",
               currentProject = "%@",
               environmentVariables = "Environment Variables: %@",
               securityPreventManualSelection = "Staying safe! I've kept you in your workspace.\nYour workspace: %@\nUsing: %@"
}

// Define path constants
struct Paths {
    static let osascriptPath = "/usr/bin/osascript"
}

// Define file extensions and formats
struct Format {
    static let xcodeProjExtension = ".xcodeproj",
               xcodeWorkExtension = ".xcworkspace",
               projectListFormat = "%d. %@\n",
               newLine = "\n",
               spaceSeparator = " ",
               commaSeparator = ","
    
    // Regex patterns
    static let quoteExtractPattern = /\"([^\"]+)\"/
    
    // Character sets
    static func newlinesCharSet() -> CharacterSet {
        return .newlines
    }
}

// Define Xcode-related constants
struct XcodeConstants {
    // Bundle IDs
    static let xcodeBundleIdentifier = "com.apple.dt.Xcode"
    
    // Issue types
    static let errorIssueType = "Error",
               warningIssueType = "Warning",
               analyzerIssueType = "Analyzer Issue",
               testFailureIssueType = "Test Failure"
    
    // Time intervals
    static let buildPollInterval = 0.5, // seconds
               runDelayInterval: UInt32 = 1 // seconds
    
    // File prefix and format
    static let filePrefix = "File:`",
               fileSuffix = "`:"
    
    // Code formatting
    static let codeBlockStart = "```",
               codeBlockEnd = "```",
               issueFormat = "%@:%d:%d [%@] %@"
}
