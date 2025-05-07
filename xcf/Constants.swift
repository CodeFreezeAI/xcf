//
//  Constants.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

// Define string constants for commands
struct Directives {
    static let xcf = "xcf"
    static let help = "help"
    static let list = "list"
    static let select = "select"
    static let run = "run"
    static let build = "build"
    static let grant = "grant"
    static let useXcf = "use xcf"
}

// Define error messages
struct ErrorMessages {
    static let noProjectSelected = "Error: No project selected"
    static let noOpenProjects = "Error: No open projects."
    static let invalidProjectSelection = "Error: Invalid project selection format. Use 'select N' where N is the project number."
    static let projectOutOfRange = "Error: Project number %@ is out of range. Available projects: 1-%@"
    static let unrecognizedDirective = "Houston we have a problem: %@ is not recognized."
    
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
    static let xcfActive = "All xcf systems go!"
    static let buildSuccess = "🐦📜 Built successfully"
    static let runSuccess = "🐦📜 Ran successfully"
    static let permissionGranted = "Permission Granted"
    static let projectSelected = "Selected project %d: %@"
    static let success = "success"
}

// Define path constants
struct Paths {
    static let osascriptPath = "/usr/bin/osascript"
}

// Define MCP server configurations
struct McpConfig {
    // Tool names
    static let listToolsName = "list_tools"
    static let xcfToolName = "xcf"
    static let snippetToolName = "code_snippet"
    
    // Tool descriptions
    static let listToolsDesc = "Lists all available tools on this server"
    static let xcfToolDesc = "Execute an XCF directive or command"
    static let snippetToolDesc = "Extract code snippets from files in the current project (use entireFile=true to get full file content)"
    
    // Server config
    static let serverName = "xcf"
    static let serverVersion = "1.0.0"
    
    // Schema parameters
    static let directiveParamName = "directive"
    static let directiveParamDesc = "The XCF directive to execute"
    static let objectType = "object"
    static let stringType = "string"
    
    // Schema keys
    static let typeKey = "type"
    static let propertiesKey = "properties"
    static let descriptionKey = "description"
    static let requiredKey = "required"
    
    // Console messages
    static let availableTools = "Available tools:\n"
    static let toolListFormat = "- %@: %@\n"
    static let directiveFound = "Directive found: %@"
    static let noDirectiveFound = "No directive found, using help"
    
    // Main app messages
    static let welcomeMessage = "welcome to xcf in pure swift\nxcodefreeze mcp local server\ncopyright 2025 codefreeze.ai\n"
    static let errorStartingServer = "Error starting MCP server: %@"
    
    // Help text
    static let helpText = """
    xcf directives:
    - xcf: Activate XCF mode
    - grant: permission to use xcode automation
    - list: [open xc projects and workspaces]
    - select #: [open xc project or workspace]
    - run: Execute the current XCF project
    - build: Build the current XCF project
    - help: Show this help information
    
    MCP features:
    - Resources: Access project information and code snippets
    - Prompts: Use pre-defined templates for common tasks
    - Tools: Execute commands, extract snippets, and more
    """
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
