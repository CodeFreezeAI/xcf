//
//  XcfMcpConfig.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//
import Foundation

// Define MCP server configurations
struct McpConfig {
    
    // Add missing type constants
    static let arrayType = "array",
               missingSourceStringParamError = "Missing source string parameter Error"
    
    // Tool names
    static let listToolsName = "list",
               xcfToolName = AppConstants.appName,
               snippetToolName = "snippet",
               quickHelpToolName = "xcf_help",
               helpToolName = "help",
               analyzerToolName = "analyzer",
               useXcfToolName = "use_xcf",
               tools = "tools",
               xcfHelp = "xcf_help"
    
    // Filesystem tool names
    static let writeFileToolName = "write_file",
               readFileToolName = "read_file",
               readDirToolName = "read_dir",
               cdDirToolName = "cd_dir",
               editFileToolName = "edit_file",
               deleteFileToolName = "delete_file",
               addDirToolName = "add_dir",
               rmDirToolName = "rm_dir",
               moveFileToolName = "move_file",
               moveDirToolName = "move_dir"
    
    // ScriptingBridge tool names
    static let openDocToolName = "open_doc",
               createDocToolName = "create_doc",
               readDocToolName = "read_doc",
               saveDocToolName = "save_doc",
               editDocToolName = "edit_doc",
               closeDocToolName = "close_doc"
    
    // Tool descriptions
    static let listToolsDesc = "Lists all available tools on this server",
               xcfToolDesc = "Execute an \(AppConstants.appName) action or command",
               snippetToolDesc = "Extract code snippets from files",
               quickHelpToolDesc = "Quick help for xcf actions only",
               helpToolDesc = "Regular help with common examples",
               analyzerToolDesc = "Analyze Swift code for potential issues",
               useXcfToolDesc = "Activate XCF mode"
    
    // Filesystem tool descriptions
    static let writeFileToolDesc = "Write content to a file",
               readFileToolDesc = "Read content from a file",
               readDirToolDesc = "List contents of a directory",
               cdDirToolDesc = "Change current directory",
               editFileToolDesc = "Edit content in a file",
               deleteFileToolDesc = "Delete a file",
               addDirToolDesc = "Create a new directory",
               rmDirToolDesc = "Remove a directory",
               moveFileToolDesc = "Move a file from one location to another",
               moveDirToolDesc = "Move a directory from one location to another"
    
    // ScriptingBridge tool descriptions
    static let openDocToolDesc = "Open a document in Xcode",
               createDocToolDesc = "Create a new document in Xcode",
               readDocToolDesc = "Read document content from Xcode",
               saveDocToolDesc = "Save document in Xcode",
               editDocToolDesc = "Edit document content in Xcode",
               closeDocToolDesc = "Close a document in Xcode"
    
    // Standalone action tool names
    static let showHelpToolName = "show_help",
               grantPermissionToolName = "grant_permission",
               runProjectToolName = "run_project",
               buildProjectToolName = "build_project",
               showCurrentProjectToolName = "show_current_project",
               showEnvToolName = "show_env",
               showFolderToolName = "show_folder",
               listProjectsToolName = "list_projects",
               selectProjectToolName = "select_project",
               analyzeSwiftCodeToolName = "analyze_swift_code"
    
    // Diff tool names
    static let createDiffFromDocToolName = "create_diff_from_doc",
               applyDiffToDocToolName = "apply_diff_to_doc",
               applyUndoDiffToDocToolName = "apply_undo_diff_to_doc",
               createDiff = "create_diff",
               applyDiff = "apply_diff",
               getAsciiDiff = "get_ascii_diff"
    
    // Diff tool descriptions
    static let createDiffFromDocToolDesc = "Create a diff from a document and store it with a hash",
               applyDiffToDocToolDesc = "Apply a diff to a document using a stored diff hash",
               applyUndoDiffToDocToolDesc = "Apply undo diff to a document using a stored diff hash"

    // Standalone action tool descriptions
    static let showHelpToolDesc = "Display help information about available commands",
               grantPermissionToolDesc = "Grant Xcode automation permissions",
               runProjectToolDesc = "Run the current Xcode project",
               buildProjectToolDesc = "Build the current Xcode project",
               showCurrentProjectToolDesc = "Show information about the currently selected project",
               showEnvToolDesc = "Display all environment variables",
               showFolderToolDesc = "Display the current working folder",
               listProjectsToolDesc = "List all open Xcode projects",
               selectProjectToolDesc = "Select an Xcode project by number",
               analyzeSwiftCodeToolDesc = "Analyze Swift code for potential issues"
    
    // Standalone action prompt names
    static let showHelpPromptName = "showHelp",
               grantPermissionPromptName = "grantPermission",
               runProjectPromptName = "runProject",
               buildProjectPromptName = "buildProject",
               showCurrentProjectPromptName = "showCurrentProject",
               showEnvPromptName = "showEnvironment",
               showFolderPromptName = "showFolder",
               listProjectsPromptName = "listProjects",
               selectProjectPromptName = "selectProject",
               analyzeSwiftCodePromptName = "analyzeSwiftCode"
    
    // Diff tool parameter names
    static let diffHashParamName = "diffHash",
               diffHashParamDesc = "SHA256 hash of the diff to apply"
    
    // Standalone action tool parameter names
    static let projectNumberParamName = "projectNumber",
               projectNumberParamDesc = "The number of the project to select",
               checkGroupsParamName = "checkGroups",
               checkGroupsParamDesc = "Check groups to perform (all, syntax, style, safety, performance, bestPractices)"
    
    // Standalone action resource names
    static let helpResourceName = "help",
               helpResourceDesc = "Help information about available commands",
               helpResourceURI = "\(AppConstants.appName)://resources/help"
    
    static let permissionResourceName = "permission",
               permissionResourceDesc = "Xcode automation permission status",
               permissionResourceURI = "\(AppConstants.appName)://resources/permission"
    
    static let projectManagementResourceName = "projectManagement",
               projectManagementResourceDesc = "Project management operations and status",
               projectManagementResourceURI = "\(AppConstants.appName)://resources/projectManagement"
    
    static let environmentResourceName = "environment",
               environmentResourceDesc = "Environment variables and system information",
               environmentResourceURI = "\(AppConstants.appName)://resources/environment"
    
    static let directoryResourceName = "directory",
               directoryResourceDesc = "Current directory and path information",
               directoryResourceURI = "\(AppConstants.appName)://resources/directory"
    
    // Server config
    static let serverName = AppConstants.appName,
               serverVersion = "1.0.4"
    
    // Resource URIs
    static let xcodeProjResourceURI = "\(AppConstants.appName)://resources/xcodeProjects",
               fileContentsResourceURI = "\(AppConstants.appName)://resources/fileContents",
               buildResultsResourceURI = "\(AppConstants.appName)://resources/buildResults"
    
    // Resource names and descriptions
    static let xcodeProjResourceName = "xcodeProjects",
               xcodeProjResourceDesc = "Currently open Xcode projects and workspaces",
               fileContentsResourceName = "fileContents",
               fileContentsResourceDesc = "Provides file contents from the workspace",
               buildResultsResourceName = "buildResults",
               buildResultsResourceDesc = "Latest Xcode build results including errors and warnings"
    
    // Prompt names and descriptions
    static let buildPromptName = "buildProject",
               buildPromptDesc = "Prompt for building a project",
               runPromptName = "runProject",
               runPromptDesc = "Prompt for running a project",
               analyzeCodePromptName = "analyzeCode",
               analyzeCodePromptDesc = "Analyze code for potential issues or improvements"
    
    // Prompt argument names and descriptions
    static let projectPathArgName = "projectPath",
               projectPathArgDesc = "Path to the Xcode project",
               filePathArgName = "filePath",
               filePathArgDesc = "Path to the file to analyze",
               includeSnippetArgName = "includeSnippet",
               includeSnippetArgDesc = "Include code snippet in results"
    
    // Filesystem parameter names and descriptions
    static let directoryPathParamName = "directoryPath",
               directoryPathParamDesc = "Path to the directory",
               fileExtensionParamName = "fileExtension",
               fileExtensionParamDesc = "Filter files by extension (e.g., 'swift')",
               contentParamName = "content",
               contentParamDesc = "Content to write to the file",
               replacementParamName = "replacement",
               replacementParamDesc = "Replacement text for the specified lines",
               useScriptingBridgeParamName = "useScriptingBridge",
               useScriptingBridgeParamDesc = "Whether to use ScriptingBridge or FileManager for the operation"
    
    // Schema parameters
    static let actionParamName = "action",
               actionParamDesc = "The xcf action to execute",
               objectType = "object",
               stringType = "string",
               integerType = "integer",
               booleanType = "boolean"
    
    // DiffTools
    static let modifiedContentParamName = "modifiedContent",
               modifiedContentParamNameDesc = "modified content to the file"
    
    // Snippet tool parameters
    static let filePathParamName = "filePath",         // Use from Diff Tools
               filePathParamDesc = "Path to the file", // Use from Diff Tools
               startLineParamName = "startLine",
               startLineParamDesc = "Starting line number (1-indexed)",
               endLineParamName = "endLine",
               endLineParamDesc = "Ending line number (1-indexed)",
               entireFileParamName = "entireFile",
               entireFileParamDesc = "Set to true to get the entire file content"
    
    // Argument names for tools
    static let startLineArgName = "startLine",
               endLineArgName = "endLine",
               entireFileArgName = "entireFile"
    
    // Schema keys
    static let typeKey = "type",
               propertiesKey = "properties",
               descriptionKey = "description",
               requiredKey = "required"
    
    // Console messages
    static let availableTools = "Available tools:\n",
               toolListFormat = "- %@: %@\n",
               availableResources = "Available resources:\n",
               resourceListFormat = "- %@ (%@): %@\n",
               availablePrompts = "Available prompts:\n",
               promptListFormat = "- %@: %@\n",
               actionFound = "Action found: %@",
               noActionFound = "No action found, using help"
    
    // Code snippet error messages
    static let missingLineParamsError = "Missing required line parameters when entireFile is false",
               missingFilePathError = "Missing required filePath parameter"
    
    // Resource error messages
    static let missingFilePathParamError = "Missing required filePath parameter for file operation",
               missingDirectoryPathParamError = "Missing required directoryPath parameter",
               unknownResourceUriError = "Unknown resource URI: %@",
               unknownPromptNameError = "Unknown prompt name: %@"
    
    // Prompt templates
    static let buildProjectTemplate = "Please build the project at path: %@",
               runProjectTemplate = "Please run the project at path: %@",
               analyzeCodeTemplate = "Please analyze the code at path: %@",
               analyzeCodeWithSnippetTemplate = "\n\n```%@\n%@\n```"
    
    // Prompt descriptions
    static let buildProjectResultDesc = "Builds the specified Xcode project",
               runProjectResultDesc = "Runs the specified Xcode project",
               analyzeCodeResultDesc = "Analyzes code for potential issues"
    
    // Parameter placeholders
    static let projectPathPlaceholder = "{{projectPath}}",
               filePathPlaceholder = "{{filePath}}"
    
    // Main app messages
    static let welcomeMessage = "**********************\n \(AppConstants.appName) Xcode MCP Server \n**** \(McpConfig.serverVersion) xfc.ai ****\n*** Copyright 2025 ***\nXCodeFreeze Automation\n***** V IX MMXXV *****\n",
               errorStartingServer = "Error starting MCP server: %@"
    
    // Help text reference
    static let helpText = HelpText.basic
    
    // MIME types
    static let plainTextMimeType = "text/plain"
    
    // Formatting
    static let newLineSeparator = "\n",
               codeBlockFormat = "```%@\n%@\n```"
    
    // Query parameters
    static let filePathQueryParam = "filePath"
    
    // Operation success messages
    static let fileReadSuccessfully = "File read successfully",
               fileWrittenSuccessfully = "File written successfully",
               fileCreatedSuccessfully = "File created successfully",
               fileEditedSuccessfully = "File edited successfully",
               fileDeletedSuccessfully = "File deleted successfully",
               fileOpenedSuccessfully = "File opened successfully",
               fileClosedSuccessfully = "File closed successfully",
               directoryCreatedSuccessfully = "Directory created successfully",
               directoryReadSuccessfully = "Directory read successfully",
               directorySelectedSuccessfully = "Directory selected successfully",
               directoryChangedSuccessfully = "Directory changed successfully",
               directoryRemovedSuccessfully = "Directory removed successfully",
               documentOpenedSuccessfully = "Document opened successfully",
               documentCreatedSuccessfully = "Document created successfully",
               documentReadSuccessfully = "Document read successfully",
               documentSavedSuccessfully = "Document saved successfully",
               documentEditedSuccessfully = "Document edited successfully",
               documentClosedSuccessfully = "Document closed successfully"
    
    // Error messages
    static let errorChangingDirectory = "Error changing directory: %@",
               errorRemovingDirectory = "Error removing directory: %@"
}
