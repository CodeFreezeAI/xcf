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
    static let list = "list"
    static let select = "select"
    static let run = "run"
    static let build = "build"
    static let grant = "grant"
    static let useXcf = "use \(AppConstants.appName)"
    static let current = "current"
    static let env = "env"
}

// Define error messages
struct ErrorMessages {
    static let noProjectSelected = "Error: No project selected"
    static let noOpenProjects = "Error: No open projects."
    static let invalidProjectSelection = "Error: Invalid project selection format. Use 'select N' where N is the project number."
    static let projectOutOfRange = "Error: Project number %@ is out of range. Available projects: 1-%@"
    static let unrecognizedAction = "Houston we have a problem: %@ is not recognized."
    
    // Xcode build errors
    static let failedToConnectXcode = "Failed to connect to Xcode"
    static let noWorkspaceFound = "No workspace document found"
    static let failedToStartBuild = "Failed to start build"
    static let failedToGetBuildResult = "Failed to get build result"
    
    // Osascript errors
    static let failedToConvertOutput = "Failed to convert output data to string."
    static let failedToExecuteOsascript = "Failed to execute osascript: %@"
    static let failedToCreateAppleScript = "Failed to create AppleScript."
    static let appleScriptError = "Error: %@"
    
    // MCP errors
    static let unknownTool = "Unknown tool: %@"
    
    // Code snippet errors
    static let invalidLineNumbers = "Code Snippet Error: Invalid line numbers."
    static let errorReadingFile = "Code Snippet Error reading file: %@"
}

// Define success messages
struct SuccessMessages {
    static let xcfActive = "All \(AppConstants.appName) systems go!"
    static let buildSuccess = "🐦📜 Built successfully"
    static let runSuccess = "🐦📜 Ran successfully"
    static let permissionGranted = "Permission Granted"
    static let projectSelected = "Selected project %d: %@"
    static let success = "success"
    static let pwdSuccess = "Current directory: %@"
    static let currentProject = "Current project: %@"
    static let environmentVariables = "Environment Variables: %@"
}

// Define path constants
struct Paths {
    static let osascriptPath = "/usr/bin/osascript"
}

// Define MCP server configurations
struct McpConfig {
    // Tool names
    static let listToolsName = "tools"
    static let xcfToolName = AppConstants.appName
    static let snippetToolName = "snippet"
    static let helpToolName = "help"
    
    // Tool descriptions
    static let listToolsDesc = "Lists all available tools on this server"
    static let xcfToolDesc = "Execute an \(AppConstants.appName) action or command"
    static let snippetToolDesc = "Extract code snippets from files in the current project (use entireFile=true to get full file content)"
    static let helpToolDesc = "Displays help information about \(AppConstants.appName) actions and usage"
    
    // Server config
    static let serverName = AppConstants.appName
    static let serverVersion = "1.0.0"
    
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
    static let missingFilePathError = "Missing required filePath parameter for code snippet"
    
    // Resource error messages
    static let missingFilePathParamError = "Missing filePath parameter"
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
    static let welcomeMessage = "welcome to \(AppConstants.appName) in pure swift\nxcodefreeze mcp local server\ncopyright 2025 codefreeze.ai\n"
    static let errorStartingServer = "Error starting MCP server: %@"
    
    // Help text
    static let helpText = """
    \(AppConstants.appName) actions:
    - use \(AppConstants.appName): Activate \(AppConstants.appName) mode
    - grant: permission to use xcode automation
    - list: [open xc projects and workspaces]
    - select #: [open xc project or workspace]
    - run: Execute the current \(AppConstants.appName) project
    - build: Build the current \(AppConstants.appName) project
    - current: Display the currently selected project
    - env: Show all environment variables
    - help: Show this help information
    """
    
    // MIME types
    static let plainTextMimeType = "text/plain"
    
    // Formatting
    static let newLineSeparator = "\n"
    static let codeBlockFormat = "```%@\n%@\n```"
    
    // Query parameters
    static let filePathQueryParam = "filePath"
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
