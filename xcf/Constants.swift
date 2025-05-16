//
//  Constants.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
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

// Define error messages
struct ErrorMessages {
    // MARK: - Project Selection Errors
    static let noProjectSelected = "No project selected yet. Use 'show' to see available projects."
    static let noOpenProjects = "I don't see any open Xcode projects. Try opening one first."
    static let invalidProjectSelection = "That's not a valid selection. Try 'open 1' to select the first project."
    static let projectOutOfRange = "Project %@ doesn't exist. I only found %@ projects."
    static let noProjectInWorkspace = "I couldn't find a project in your workspace."
    
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

// Define MCP server configurations
struct McpConfig {
    // Tool names
    static let listToolsName = "list"
    static let xcfToolName = AppConstants.appName
    static let snippetToolName = "snippet"
    static let quickHelpToolName = "?"
    static let detailedHelpToolName = "help"
    static let analyzerToolName = "analyzer"
    static let useXcfToolName = "use_xcf"
    
    // Filesystem tool names
    static let writeFileToolName = "write_file"
    static let readFileToolName = "read_file"
    static let readDirToolName = "read_dir"
    static let cdDirToolName = "cd_dir"
    static let editFileToolName = "edit_file"
    static let deleteFileToolName = "delete_file"
    static let addDirToolName = "add_dir"
    static let rmDirToolName = "rm_dir"
    
    // ScriptingBridge tool names
    static let openDocToolName = "open_doc"
    static let createDocToolName = "create_doc"
    static let readDocToolName = "read_doc"
    static let saveDocToolName = "save_doc"
    static let editDocToolName = "edit_doc"
    
    // Tool descriptions
    static let listToolsDesc = "Lists all available tools on this server"
    static let xcfToolDesc = "Execute an \(AppConstants.appName) action or command"
    static let snippetToolDesc = "Extract code snippets from files in the current project"
    static let quickHelpToolDesc = "Quick help for xcf commands"
    static let detailedHelpToolDesc = "Detailed help for all available tools and commands"
    static let analyzerToolDesc = "Analyze Swift code for potential issues"
    static let useXcfToolDesc = "Activate XCF mode"
    
    // Filesystem tool descriptions
    static let writeFileToolDesc = "Write content to a file"
    static let readFileToolDesc = "Read content from a file"
    static let readDirToolDesc = "List contents of a directory"
    static let cdDirToolDesc = "Change current directory"
    static let editFileToolDesc = "Edit content in a file"
    static let deleteFileToolDesc = "Delete a file"
    static let addDirToolDesc = "Create a new directory"
    static let rmDirToolDesc = "Remove a directory"
    
    // ScriptingBridge tool descriptions
    static let openDocToolDesc = "Open a document in Xcode"
    static let createDocToolDesc = "Create a new document in Xcode"
    static let readDocToolDesc = "Read document content from Xcode"
    static let saveDocToolDesc = "Save document in Xcode"
    static let editDocToolDesc = "Edit document content in Xcode"
    
    // Server config
    static let serverName = AppConstants.appName
    static let serverVersion = "1.0.4 alpha 1"
    
    // Resource URIs
    static let xcodeProjResourceURI = "\(AppConstants.appName)://resources/xcodeProjects"
    static let fileContentsResourceURI = "\(AppConstants.appName)://resources/fileContents"
    static let buildResultsResourceURI = "\(AppConstants.appName)://resources/buildResults"
    
    // Resource names and descriptions
    static let xcodeProjResourceName = "xcodeProjects"
    static let xcodeProjResourceDesc = "Currently open Xcode projects and workspaces"
    static let fileContentsResourceName = "fileContents"
    static let fileContentsResourceDesc = "Provides file contents from the workspace"
    static let buildResultsResourceName = "buildResults"
    static let buildResultsResourceDesc = "Latest Xcode build results including errors and warnings"
    
    // Prompt names and descriptions
    static let buildPromptName = "buildProject"
    static let buildPromptDesc = "Prompt for building a project"
    static let runPromptName = "runProject"
    static let runPromptDesc = "Prompt for running a project"
    static let analyzeCodePromptName = "analyzeCode"
    static let analyzeCodePromptDesc = "Analyze code for potential issues or improvements"
    
    // Prompt argument names and descriptions
    static let projectPathArgName = "projectPath"
    static let projectPathArgDesc = "Path to the Xcode project"
    static let filePathArgName = "filePath"
    static let filePathArgDesc = "Path to the file to analyze"
    static let includeSnippetArgName = "includeSnippet"
    static let includeSnippetArgDesc = "Include code snippet in results"
    
    // Filesystem parameter names and descriptions
    static let directoryPathParamName = "directoryPath"
    static let directoryPathParamDesc = "Path to the directory"
    static let fileExtensionParamName = "fileExtension"
    static let fileExtensionParamDesc = "Filter files by extension (e.g., 'swift')"
    static let contentParamName = "content"
    static let contentParamDesc = "Content to write to the file"
    static let replacementParamName = "replacement"
    static let replacementParamDesc = "Replacement text for the specified lines"
    static let useScriptingBridgeParamName = "useScriptingBridge"
    static let useScriptingBridgeParamDesc = "Whether to use ScriptingBridge or FileManager for the operation"
    
    // Schema parameters
    static let actionParamName = "action"
    static let actionParamDesc = "The xcf action to execute"
    static let objectType = "object"
    static let stringType = "string"
    static let integerType = "integer"
    static let booleanType = "boolean"
    
    // Snippet tool parameters
    static let filePathParamName = "filePath"
    static let filePathParamDesc = "Path to the file to extract snippet from"
    static let startLineParamName = "startLine"
    static let startLineParamDesc = "Starting line number (1-indexed)"
    static let endLineParamName = "endLine"
    static let endLineParamDesc = "Ending line number (1-indexed)"
    static let entireFileParamName = "entireFile"
    static let entireFileParamDesc = "Set to true to get the entire file content"
    
    // Schema keys
    static let typeKey = "type"
    static let propertiesKey = "properties"
    static let descriptionKey = "description"
    static let requiredKey = "required"
    
    // Console messages
    static let availableTools = "Available tools:\n"
    static let toolListFormat = "- %@: %@\n"
    static let availableResources = "Available resources:\n"
    static let resourceListFormat = "- %@ (%@): %@\n"
    static let availablePrompts = "Available prompts:\n"
    static let promptListFormat = "- %@: %@\n"
    static let actionFound = "Action found: %@"
    static let noActionFound = "No action found, using help"
    
    // Code snippet error messages
    static let missingLineParamsError = "Missing required line parameters when entireFile is false"
    static let missingFilePathError = "Missing required filePath parameter"
    
    // Resource error messages
    static let missingFilePathParamError = "Missing required filePath parameter for file operation"
    static let missingDirectoryPathParamError = "Missing required directoryPath parameter"
    static let unknownResourceUriError = "Unknown resource URI: %@"
    static let unknownPromptNameError = "Unknown prompt name: %@"
    
    // Prompt templates
    static let buildProjectTemplate = "Please build the project at path: %@"
    static let runProjectTemplate = "Please run the project at path: %@"
    static let analyzeCodeTemplate = "Please analyze the code at path: %@"
    static let analyzeCodeWithSnippetTemplate = "\n\n```%@\n%@\n```"
    
    // Prompt descriptions
    static let buildProjectResultDesc = "Builds the specified Xcode project"
    static let runProjectResultDesc = "Runs the specified Xcode project"
    static let analyzeCodeResultDesc = "Analyzes code for potential issues"
    
    // Parameter placeholders
    static let projectPathPlaceholder = "{{projectPath}}"
    static let filePathPlaceholder = "{{filePath}}"
    
    // Main app messages
    static let welcomeMessage = "**********************\n \(AppConstants.appName) Xcode MCP Server \n**** 1.0.2 xfc.ai ****\n*** Copyright 2025 ***\nXCodeFreeze Automation\n***** V IX MMXXV *****\n"
    static let errorStartingServer = "Error starting MCP server: %@"
    
    // Help text
    static let helpText = """
xcf <action>:
grant - Grant Xcode automation permissions
show - List open projects
open # - Select project by number
current - Show selected project
build - Build current project
run - Run current project
env - Show environment variables
pwd - Show current folder (aliases: dir, path)
analyze <file> - Analyze Swift code
lz <file> - Short for analyze
? - Show this help
help - Show detailed tool help

Examples:
xcf show
xcf open 1
xcf current
xcf build
xcf run
xcf analyze main.swift
xcf lz main.swift
"""
    
    // MIME types
    static let plainTextMimeType = "text/plain"
    
    // Formatting
    static let newLineSeparator = "\n"
    static let codeBlockFormat = "```%@\n%@\n```"
    
    // Query parameters
    static let filePathQueryParam = "filePath"
    
    // Operation success messages
    static let fileReadSuccessfully = "File read successfully"
    static let fileWrittenSuccessfully = "File written successfully"
    static let fileCreatedSuccessfully = "File created successfully"
    static let fileEditedSuccessfully = "File edited successfully"
    static let fileDeletedSuccessfully = "File deleted successfully"
    static let fileOpenedSuccessfully = "File opened successfully"
    static let fileClosedSuccessfully = "File closed successfully"
    static let directoryCreatedSuccessfully = "Directory created successfully"
    static let directoryReadSuccessfully = "Directory read successfully"
    static let directorySelectedSuccessfully = "Directory selected successfully"
    static let directoryChangedSuccessfully = "Directory changed successfully"
    static let directoryRemovedSuccessfully = "Directory removed successfully"
    static let documentOpenedSuccessfully = "Document opened successfully"
    static let documentCreatedSuccessfully = "Document created successfully"
    static let documentReadSuccessfully = "Document read successfully"
    static let documentSavedSuccessfully = "Document saved successfully"
    static let documentEditedSuccessfully = "Document edited successfully"
    
    // Error messages
    static let errorChangingDirectory = "Error changing directory: %@"
    static let errorRemovingDirectory = "Error removing directory: %@"
}

// Define file extensions and formats
struct Format {
    static let xcodeFileExtension = ".xc"
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

// Help text for tools
let toolsHelpText = """
Available Tools:

File Operations:
- read_file: Read contents of a file
  Parameters:
    - filePath: Path to the file to read
    Example: {"name": "read_file", "arguments": {"filePath": "path/to/file"}}

- write_file: Write content to a file
  Parameters:
    - filePath: Path to the file to write
    - content: Content to write to the file
    Example: {"name": "write_file", "arguments": {"filePath": "path/to/file", "content": "file content"}}

- create_file: Create a new file with FileManager
  Parameters:
    - filePath: Path where to create the file
    - content: Initial content (optional)
    Example: {"name": "create_file", "arguments": {"filePath": "path/to/file", "content": "initial content"}}

- new_file: Create a new file in Xcode
  Parameters:
    - filePath: Path where to create the file
    - content: Initial content (optional)
    Example: {"name": "new_file", "arguments": {"filePath": "path/to/file", "content": "initial content"}}

- delete_file: Delete a file with FileManager
  Parameters:
    - filePath: Path to the file to delete
    Example: {"name": "delete_file", "arguments": {"filePath": "path/to/file"}}

- remove_file: Remove a file from Xcode
  Parameters:
    - filePath: Path to the file to remove
    Example: {"name": "remove_file", "arguments": {"filePath": "path/to/file"}}

- open_file: Open a file in Xcode
  Parameters:
    - filePath: Path to the file to open
    Example: {"name": "open_file", "arguments": {"filePath": "path/to/file"}}

- close_file: Close a file in Xcode
  Parameters:
    - filePath: Path to the file to close
    Example: {"name": "close_file", "arguments": {"filePath": "path/to/file"}}

Directory Operations:
- read_dir: List contents of a directory
  Parameters:
    - directoryPath: Path to the directory to read
    - fileExtension: Filter by file extension
    Example: {"name": "read_dir", "arguments": {"directoryPath": "path/to/dir", "fileExtension": "swift"}}

- create_dir: Create a new directory
  Parameters:
    - directoryPath: Path where to create the directory
    Example: {"name": "create_dir", "arguments": {"directoryPath": "path/to/dir"}}

- select_dir: Show a dialog to select a directory
  Parameters: none
  Example: {"name": "select_dir", "arguments": {}}

Code Analysis:
- snippet: Extract code snippets from files
  Parameters:
    - filePath: Path to the file
    - entireFile: true to get entire file, false for line range
    - startLine: Starting line number (when entireFile is false)
    - endLine: Ending line number (when entireFile is false)
    Example: {"name": "snippet", "arguments": {"filePath": "path/to/file", "entireFile": true}}
    Example: {"name": "snippet", "arguments": {"filePath": "path/to/file", "startLine": 10, "endLine": 20}}

- analyzer: Analyze Swift code for potential issues
  Parameters:
    - filePath: Path to the file to analyze
    - entireFile: true to analyze entire file, false for line range
    - startLine: Starting line number (when entireFile is false)
    - endLine: Ending line number (when entireFile is false)
    Example: {"name": "analyzer", "arguments": {"filePath": "path/to/file", "entireFile": true}}
    Example: {"name": "analyzer", "arguments": {"filePath": "path/to/file", "startLine": 10, "endLine": 20}}

Other Tools:
- list: List all available tools
  Parameters: none
  Example: {"name": "list", "arguments": {}}

- help: Show this help information
  Parameters: none
  Example: {"name": "help", "arguments": {}}

Note: All file paths can be absolute or relative to the current working directory.
"""
