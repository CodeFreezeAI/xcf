//
//  XcfConstants.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation
import AppKit

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
    static let quickHelpToolName = "xcf_help"
    static let helpToolName = "help"
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
    static let moveFileToolName = "move_file"
    static let moveDirToolName = "move_dir"
    
    // ScriptingBridge tool names
    static let openDocToolName = "open_doc"
    static let createDocToolName = "create_doc"
    static let readDocToolName = "read_doc"
    static let saveDocToolName = "save_doc"
    static let editDocToolName = "edit_doc"
    static let closeDocToolName = "close_doc"
    
    // Tool descriptions
    static let listToolsDesc = "Lists all available tools on this server"
    static let xcfToolDesc = "Execute an \(AppConstants.appName) action or command"
    static let snippetToolDesc = "Extract code snippets from files"
    static let quickHelpToolDesc = "Quick help for xcf actions only"
    static let helpToolDesc = "Regular help with common examples"
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
    static let moveFileToolDesc = "Move a file from one location to another"
    static let moveDirToolDesc = "Move a directory from one location to another"
    
    // ScriptingBridge tool descriptions
    static let openDocToolDesc = "Open a document in Xcode"
    static let createDocToolDesc = "Create a new document in Xcode"
    static let readDocToolDesc = "Read document content from Xcode"
    static let saveDocToolDesc = "Save document in Xcode"
    static let editDocToolDesc = "Edit document content in Xcode"
    static let closeDocToolDesc = "Close a document in Xcode"
    
    // Standalone action tool names
    static let showHelpToolName = "show_help"
    static let grantPermissionToolName = "grant_permission"
    static let runProjectToolName = "run_project"
    static let buildProjectToolName = "build_project"
    static let showCurrentProjectToolName = "show_current_project"
    static let showEnvToolName = "show_env"
    static let showFolderToolName = "show_folder"
    static let listProjectsToolName = "list_projects"
    static let selectProjectToolName = "select_project"
    static let analyzeSwiftCodeToolName = "analyze_swift_code"
    
    // Standalone action tool descriptions
    static let showHelpToolDesc = "Display help information about available commands"
    static let grantPermissionToolDesc = "Grant Xcode automation permissions"
    static let runProjectToolDesc = "Run the current Xcode project"
    static let buildProjectToolDesc = "Build the current Xcode project"
    static let showCurrentProjectToolDesc = "Show information about the currently selected project"
    static let showEnvToolDesc = "Display all environment variables"
    static let showFolderToolDesc = "Display the current working folder"
    static let listProjectsToolDesc = "List all open Xcode projects"
    static let selectProjectToolDesc = "Select an Xcode project by number"
    static let analyzeSwiftCodeToolDesc = "Analyze Swift code for potential issues"
    
    // Standalone action prompt names
    static let showHelpPromptName = "showHelp"
    static let grantPermissionPromptName = "grantPermission"
    static let runProjectPromptName = "runProject"
    static let buildProjectPromptName = "buildProject"
    static let showCurrentProjectPromptName = "showCurrentProject"
    static let showEnvPromptName = "showEnvironment"
    static let showFolderPromptName = "showFolder"
    static let listProjectsPromptName = "listProjects"
    static let selectProjectPromptName = "selectProject"
    static let analyzeSwiftCodePromptName = "analyzeSwiftCode"
    
    // Standalone action tool parameter names
    static let projectNumberParamName = "projectNumber"
    static let projectNumberParamDesc = "The number of the project to select"
    static let checkGroupsParamName = "checkGroups"
    static let checkGroupsParamDesc = "Check groups to perform (all, syntax, style, safety, performance, bestPractices)"
    
    // Standalone action resource names
    static let helpResourceName = "help"
    static let helpResourceDesc = "Help information about available commands"
    static let helpResourceURI = "\(AppConstants.appName)://resources/help"
    
    static let permissionResourceName = "permission"
    static let permissionResourceDesc = "Xcode automation permission status"
    static let permissionResourceURI = "\(AppConstants.appName)://resources/permission"
    
    static let projectManagementResourceName = "projectManagement"
    static let projectManagementResourceDesc = "Project management operations and status"
    static let projectManagementResourceURI = "\(AppConstants.appName)://resources/projectManagement"
    
    static let environmentResourceName = "environment"
    static let environmentResourceDesc = "Environment variables and system information"
    static let environmentResourceURI = "\(AppConstants.appName)://resources/environment"
    
    static let directoryResourceName = "directory"
    static let directoryResourceDesc = "Current directory and path information"
    static let directoryResourceURI = "\(AppConstants.appName)://resources/directory"
    
    // Server config
    static let serverName = AppConstants.appName
    static let serverVersion = "1.0.4"
    
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
    static let welcomeMessage = "**********************\n \(AppConstants.appName) Xcode MCP Server \n**** \(McpConfig.serverVersion) xfc.ai ****\n*** Copyright 2025 ***\nXCodeFreeze Automation\n***** V IX MMXXV *****\n"
    static let errorStartingServer = "Error starting MCP server: %@"
    
    // Help text
    static let helpText = HelpText.basic
    
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
    static let documentClosedSuccessfully = "Document closed successfully"
    
    // Error messages
    static let errorChangingDirectory = "Error changing directory: %@"
    static let errorRemovingDirectory = "Error removing directory: %@"
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

// Define help text
struct HelpText {
    // Quick help for xcf actions only
    static let basic = """
XCF Actions:
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

Examples:
xcf show
xcf open 1
xcf current
xcf build
xcf run
xcf analyze main.swift
xcf lz main.swift
"""

    // Regular help with common examples
    static let detailed = """
Tool Commands:

File Tools:
read_file <file>
Read content from a file
Example: read_file main.swift
Example: read_file src/utils.swift
Example: read_file ../shared/config.swift
Example: read_file ../../other/project/file.swift
Example: read_file /Users/username/Projects/app/main.swift

write_file <file> <content>
Write content to a file
Example: write_file test.txt "Hello World"
Example: write_file src/config.json '{"key": "value"}'
Example: write_file ../shared/types.swift 'import Foundation'

edit_file <file> <start> <end> <content>
Edit specific lines in a file
Example: edit_file main.swift 10 20 "new content"
Example: edit_file src/test.swift 5 5 "import UIKit"
Example: edit_file ../shared/types.swift 1 10 "new code"

delete_file <file>
Delete a file
Example: delete_file test.txt
Example: delete_file src/old/backup.swift
Example: delete_file ../backup/old.swift

Directory Tools:
cd_dir <path>
Change directory
Example: cd_dir .
Example: cd_dir src
Example: cd_dir ..
Example: cd_dir ../shared

read_dir [path] [extension]
List directory contents
Example: read_dir .
Example: read_dir src
Example: read_dir ../shared
Example: read_dir src swift

add_dir <path>
Create directory
Example: add_dir utils
Example: add_dir src/models
Example: add_dir ../shared/types

rm_dir <path>
Remove directory
Example: rm_dir temp
Example: rm_dir src/cache
Example: rm_dir ../old

Xcode Tools:
open_doc <file>
Open document in Xcode
Example: open_doc main.swift
Example: open_doc src/views/main.swift
Example: open_doc ../shared/helpers.swift

create_doc <file> [content]
Create new Xcode document
Example: create_doc test.swift
Example: create_doc src/models/user.swift
Example: create_doc ../shared/types.swift

read_doc <file>
Read Xcode document
Example: read_doc main.swift
Example: read_doc src/views/main.swift
Example: read_doc ../shared/helpers.swift

save_doc <file>
Save Xcode document
Example: save_doc main.swift
Example: save_doc src/views/main.swift
Example: save_doc ../shared/helpers.swift

edit_doc <file> <start> <end> <content>
Edit Xcode document
Example: edit_doc main.swift 10 20 "new code"
Example: edit_doc src/views/main.swift 5 10 "new code"
Example: edit_doc ../shared/helpers.swift 1 5 "new code"

Analysis Tools:
snippet <file> [start] [end]
Extract code snippets
Example: snippet main.swift
Example: snippet src/utils.swift
Example: snippet ../shared/types.swift
Example: snippet main.swift 10 20

analyzer <file> [start] [end]
Analyze Swift code
Example: analyzer main.swift
Example: analyzer src/models/user.swift
Example: analyzer ../shared/types.swift
Example: analyzer main.swift 10 20

Notes:
- All paths can be:
  - In current directory: file.swift
  - In child directories: src/file.swift
  - In parent directory: ../file.swift
  - Multiple directories up: ../../file.swift
  - Full system paths: /Users/username/project/file.swift
- Content with spaces should be quoted
- Use either ' or " for quoting content
"""

    // Super detailed help with all tools and examples
    static let toolsReference = """
MCP Tool Reference

Core Tools:
xcf
Description: Execute an xcf action or command
Required Parameters:
  - action: string (The xcf action to execute)
Example: mcp_xcf_xcf action="build"
Example: mcp_xcf_xcf action="run"

list
Description: Lists all available tools on this server
Parameters: none (type: string)
Example: mcp_xcf_list

xcf_help
Description: Quick help for xcf commands
Parameters: none (type: string)
Example: mcp_xcf_xcf action="xcf_help"

help
Description: Regular help with common examples
Parameters: none (type: string)
Example: mcp_xcf_xcf action="help"

File Operations:
snippet
Description: Extract code snippets from files in the current project
Required Parameters:
  - filePath: string (Path to the file to extract snippet from)
Optional Parameters:
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - entireFile: boolean (Set to true to get the entire file content)
Example: mcp_xcf_snippet filePath="main.swift" entireFile=true
Example: mcp_xcf_snippet filePath="main.swift" startLine=10 endLine=20

analyzer
Description: Analyze Swift code for potential issues
Required Parameters:
  - filePath: string (Path to the file to extract snippet from)
Optional Parameters:
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - entireFile: boolean (Set to true to get the entire file content)
Example: mcp_xcf_analyzer filePath="main.swift" entireFile=true
Example: mcp_xcf_analyzer filePath="main.swift" startLine=10 endLine=20

read_dir
Description: List contents of a directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Optional Parameters:
  - fileExtension: string (Filter files by extension, e.g., 'swift')
Example: mcp_xcf_read_dir directoryPath="src"
Example: mcp_xcf_read_dir directoryPath="src" fileExtension="swift"

write_file
Description: Write content to a file
Required Parameters:
  - filePath: string (Path to the file to write to)
  - content: string (Content to write to the file)
Example: mcp_xcf_write_file filePath="main.swift" content="print(\"Hello\")"

read_file
Description: Read content from a file
Required Parameters:
  - filePath: string (Path to the file to read from)
Example: mcp_xcf_read_file filePath="main.swift"

cd_dir
Description: Change current directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Example: mcp_xcf_cd_dir directoryPath="src"

edit_file
Description: Edit content in a file
Required Parameters:
  - filePath: string (Path to the file to edit)
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - replacement: string (Replacement text for the specified lines)
Example: mcp_xcf_edit_file filePath="main.swift" startLine=10 endLine=20 replacement="new code"

delete_file
Description: Delete a file
Required Parameters:
  - filePath: string (Path to the file to delete)
Example: mcp_xcf_delete_file filePath="old.swift"

Directory Operations:
add_dir
Description: Create a new directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Example: mcp_xcf_add_dir directoryPath="src/models"

rm_dir
Description: Remove a directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Example: mcp_xcf_rm_dir directoryPath="old"

Xcode Document Operations:
open_doc
Description: Open a document in Xcode
Required Parameters:
  - filePath: string (Path to the file to open)
Example: mcp_xcf_open_doc filePath="main.swift"

create_doc
Description: Create a new document in Xcode
Required Parameters:
  - filePath: string (Path to the file to create)
Optional Parameters:
  - content: string (Content to write to the file)
Example: mcp_xcf_create_doc filePath="new.swift"
Example: mcp_xcf_create_doc filePath="new.swift" content="import Foundation"

read_doc
Description: Read document content from Xcode
Required Parameters:
  - filePath: string (Path to the file to read)
Example: mcp_xcf_read_doc filePath="main.swift"

save_doc
Description: Save document in Xcode
Required Parameters:
  - filePath: string (Path to the file to save)
Example: mcp_xcf_save_doc filePath="main.swift"

edit_doc
Description: Edit document content in Xcode
Required Parameters:
  - filePath: string (Path to the file to edit)
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - replacement: string (Replacement text for the specified lines)
Example: mcp_xcf_edit_doc filePath="main.swift" startLine=10 endLine=20 replacement="new code"

Mode Activation:
use_xcf
Description: Activate XCF mode
Parameters: none (type: string)
Example: mcp_xcf_use_xcf

Parameter Types:
- string: Text values, use quotes for values with spaces
- integer: Whole numbers, 1-indexed for line numbers
- boolean: true or false
- object: Complex parameter type containing multiple values

Notes:
- All file paths can be:
  - Relative to current directory: main.swift
  - In subdirectories: src/main.swift
  - In parent directory: ../main.swift
  - Full system paths: /Users/username/project/main.swift
- Line numbers are always 1-indexed
- Content with spaces must be quoted
- Boolean values are specified as true or false (lowercase)
- All MCP calls start with mcp_xcf_
"""
}
