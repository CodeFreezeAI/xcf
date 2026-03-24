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
    
    // Tool name (single consolidated tool)
    static let xcfToolName = AppConstants.appName
    
    // Tool descriptions
    static let xcfToolDesc = "Xcode automation tool. Actions: help, build, run, show, open <n>, current, grant, env, pwd, analyze <file>, snippet <file>, read <file>, readdir <path>, cd <path>"
    
    // Resource names
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
               serverVersion = "1.1.0"
    
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
               actionParamDesc = "The action to execute (e.g., build, run, show, open 1, current, grant, env, pwd, analyze file.swift, snippet file.swift, read file.swift, readdir . swift, cd src, help)",
               objectType = "object",
               stringType = "string",
               integerType = "integer",
               booleanType = "boolean"
    
    // Snippet tool parameters
    static let filePathParamName = "filePath",
               filePathParamDesc = "Path to the file",
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
               directoryRemovedSuccessfully = "Directory removed successfully"
    
    // Error messages
    static let errorChangingDirectory = "Error changing directory: %@",
               errorRemovingDirectory = "Error removing directory: %@"
}
