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
    static let xcf = AppConstants.appName
    static let help = "help"
    static let show = "show"
    static let open = "open"
    static let run = "run"
    static let build = "build"
    static let grant = "grant"
    static let current = "current"
    static let env = "env"
    static let pwd = "pwd"
    static let dir = "dir"
    static let path = "path"
    static let analyze = "analyze"
    static let lz = "lz" // Short alias for analyze
}

// Environment variable constants
struct EnvVarKeys {
    static let xcodeProject = "XCODE_PROJECT"
    static let workspaceFolderPaths = "WORKSPACE_FOLDER_PATHS"
    static let xcodeProjectFolder = "XCODE_PROJECT_FOLDER"
    static let xcodeProjectPath = "XCODE_PROJECT_PATH"
}

// Define error messages
struct ErrorMessages {
    // MARK: - Project Selection Errors
    static let noProjectSelected = "No project selected yet. Use 'show' to see available projects."
    static let noOpenProjects = "I don't see any open Xcode projects. Try opening one first."
    static let invalidProjectSelection = "That's not a valid selection. Try 'open 1' to select the first project."
    static let projectOutOfRange = "Project %@ doesn't exist. I only found %@ projects."
    static let noProjectInWorkspace = "I couldn't find a project in your workspace."
    static let invalidProjectPath = "Warning: %@ is not a valid Xcode project or workspace path"
    
    // MARK: - Action Errors
    static let unrecognizedAction = "I don't understand '%@'. Try 'help' to see what I can do."
    static let toolCallError = "Error executing tool '%@': %@"
    
    // MARK: - Xcode Connection Errors
    static let failedToConnectXcode = "I couldn't connect to Xcode. Is it running?"
    static let noWorkspaceFound = "I couldn't find a workspace document. Try opening an Xcode project first."
    
    // MARK: - Build Errors
    static let failedToStartBuild = "I had trouble starting the build. Please try again."
    static let failedToGetBuildResult = "I couldn't get the build results. Something went wrong."
    static let errorGettingBuildResults = "Error getting build results: %@"
    
    // MARK: - File Operation Errors
    static let errorReadingFile = "Error reading file: %@"
    static let errorWritingFile = "Error writing file: %@"
    static let errorCreatingFile = "Error creating file: %@"
    static let errorEditingFile = "Error editing file: %@"
    static let errorDeletingFile = "Error deleting file: %@"
    static let errorOpeningFile = "Error opening file: %@"
    static let errorClosingFile = "Error closing file: %@"
    static let errorReadingDirectory = "Error reading directory: %@"
    static let errorCreatingDirectory = "Error creating directory: %@"
    static let errorSelectingDirectory = "Error selecting directory: %@"
    static let errorListingProjects = "Error listing projects: %@"
    static let fileNotFound = "File not found: %@"
    static let directoryNotFound = "Directory not found: %@"
    static let invalidFilePath = "Invalid file path: %@"
    static let invalidDirectoryPath = "Invalid directory path: %@"
    static let fileAlreadyExists = "File already exists: %@"
    static let directoryAlreadyExists = "Directory already exists: %@"
    static let permissionDenied = "Permission denied: %@"
    static let unknownFileError = "Unknown error occurred while operating on: %@"
    
    // MARK: - Osascript Errors
    static let failedToConvertOutput = "Failed to convert output data to string."
    static let failedToExecuteOsascript = "Failed to execute osascript: %@"
    static let failedToCreateAppleScript = "Failed to create AppleScript."
    static let appleScriptError = "Error: %@"
    
    // MARK: - MCP Errors
    static let unknownTool = "Unknown tool: %@"
    
    // MARK: - Code Snippet Errors
    static let missingLineParamsError = "Missing required line parameters when entireFile is false"
    static let missingFilePathError = "Missing required filePath parameter"
    static let invalidLineNumbers = "Those line numbers don't look right. Please check them."
    
    // Resource error messages
    static let missingFilePathParamError = "Missing required filePath parameter for file operation"
    static let missingDirectoryPathParamError = "Missing required directoryPath parameter"
    static let unknownResourceUriError = "Unknown resource URI: %@"
    static let unknownPromptNameError = "Unknown prompt name: %@"
    
    // Directory operation errors
    static let errorChangingDirectory = "Error changing directory: %@"
    static let errorRemovingDirectory = "Error removing directory: %@"
    
    // Error message for creating a diff
    static let errorCreatingDiff = "Error creating diff: %@"
    
}

// Define success messages
struct SuccessMessages {
    static let xcfActive = "All \(AppConstants.appName) systems go!"
    static let buildSuccess = "🐦📜 Built successfully"
    static let runSuccess = "🐦📜 Ran successfully"
    static let permissionGranted = "Permission Granted"
    static let success = "success"
    static let pwdSuccess = "Current directory: %@"
    static let currentProject = "%@"
    static let environmentVariables = "Environment Variables: %@"
    static let securityPreventManualSelection = "Staying safe! I've kept you in your workspace.\nYour workspace: %@\nUsing: %@"
}

// Define path constants
struct Paths {
    static let osascriptPath = "/usr/bin/osascript"
}

// Define file extensions and formats
struct Format {
    static let xcodeProjExtension = ".xcodeproj"
    static let xcodeWorkExtension = ".xcworkspace"
    static let projectListFormat = "%d. %@\n"
    static let newLine = "\n"
    static let spaceSeparator = " "
    static let commaSeparator = ","
    
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
    static let errorIssueType = "Error"
    static let warningIssueType = "Warning"
    static let analyzerIssueType = "Analyzer Issue"
    static let testFailureIssueType = "Test Failure"
    
    // Time intervals
    static let buildPollInterval = 0.5 // seconds
    static let runDelayInterval: UInt32 = 1 // seconds
    
    // File prefix and format
    static let filePrefix = "File:`"
    static let fileSuffix = "`:"
    
    // Code formatting
    static let codeBlockStart = "```"
    static let codeBlockEnd = "```"
    static let issueFormat = "%@:%d:%d [%@] %@"
} 
