//
//  McpServer.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation
import MCP

/// McpServer handles all MCP protocol interactions for the xcf tool.
/// It defines tools, resources, and prompts, and configures the MCP server with appropriate handlers.
struct McpServer {
    // MARK: - Tool Definitions
    static var XcfScript = XcfSwiftScript.shared
    /// Tool for listing available tools
    static let listToolsTool = Tool(
        name: McpConfig.listToolsName,
        description: McpConfig.listToolsDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.stringType)
        ])
    )

    /// Tool for quick help (formerly help)
    static let quickHelpTool = Tool(
        name: McpConfig.quickHelpToolName,
        description: McpConfig.quickHelpToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.stringType)
        ])
    )

    /// Tool for detailed help
    static let detailedHelpTool = Tool(
        name: McpConfig.detailedHelpToolName,
        description: McpConfig.detailedHelpToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.stringType)
        ])
    )

    /// Tool for executing xcf actions
    static let xcfTool = Tool(
        name: McpConfig.xcfToolName,
        description: McpConfig.xcfToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.actionParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.actionParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.actionParamName)])
        ])
    )
    
    /// Tool for extracting code snippets from files
    static let snippetTool = Tool(
        name: McpConfig.snippetToolName,
        description: McpConfig.snippetToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ]),
                McpConfig.startLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                ]),
                McpConfig.endLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                ]),
                McpConfig.entireFileParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.booleanType),
                    McpConfig.descriptionKey: .string(McpConfig.entireFileParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )
    
    /// Tool for analyzing Swift code
    static let analyzerTool = Tool(
        name: McpConfig.analyzerToolName,
        description: McpConfig.analyzerToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ]),
                McpConfig.startLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                ]),
                McpConfig.endLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                ]),
                McpConfig.entireFileParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.booleanType),
                    McpConfig.descriptionKey: .string(McpConfig.entireFileParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )
    
    /// Tool for writing files
    static let writeFileTool = Tool(
        name: McpConfig.writeFileToolName,
        description: McpConfig.writeFileToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ]),
                McpConfig.contentParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.contentParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName), .string(McpConfig.contentParamName)])
        ])
    )

    /// Tool for reading files
    static let readFileTool = Tool(
        name: McpConfig.readFileToolName,
        description: McpConfig.readFileToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )

    /// Tool for changing directory
    static let cdDirTool = Tool(
        name: McpConfig.cdDirToolName,
        description: McpConfig.cdDirToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.directoryPathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
        ])
    )

    /// Tool for editing files
    static let editFileTool = Tool(
        name: McpConfig.editFileToolName,
        description: McpConfig.editFileToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ]),
                McpConfig.startLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                ]),
                McpConfig.endLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                ]),
                McpConfig.replacementParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.replacementParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([
                .string(McpConfig.filePathParamName),
                .string(McpConfig.startLineParamName),
                .string(McpConfig.endLineParamName),
                .string(McpConfig.replacementParamName)
            ])
        ])
    )

    /// Tool for deleting files
    static let deleteFileTool = Tool(
        name: McpConfig.deleteFileToolName,
        description: McpConfig.deleteFileToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )

    /// Tool for adding directories
    static let addDirTool = Tool(
        name: McpConfig.addDirToolName,
        description: McpConfig.addDirToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.directoryPathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
        ])
    )

    /// Tool for removing directories
    static let rmDirTool = Tool(
        name: McpConfig.rmDirToolName,
        description: McpConfig.rmDirToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.directoryPathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
        ])
    )

    /// Tool for opening documents in Xcode
    static let openDocTool = Tool(
        name: McpConfig.openDocToolName,
        description: McpConfig.openDocToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )

    /// Tool for creating documents in Xcode
    static let createDocTool = Tool(
        name: McpConfig.createDocToolName,
        description: McpConfig.createDocToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ]),
                McpConfig.contentParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.contentParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )

    /// Tool for reading documents from Xcode
    static let readDocTool = Tool(
        name: McpConfig.readDocToolName,
        description: McpConfig.readDocToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )

    /// Tool for saving documents in Xcode
    static let saveDocTool = Tool(
        name: McpConfig.saveDocToolName,
        description: McpConfig.saveDocToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
        ])
    )

    /// Tool for editing documents in Xcode
    static let editDocTool = Tool(
        name: McpConfig.editDocToolName,
        description: McpConfig.editDocToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.filePathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                ]),
                McpConfig.startLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                ]),
                McpConfig.endLineParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                ]),
                McpConfig.replacementParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.replacementParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([
                .string(McpConfig.filePathParamName),
                .string(McpConfig.startLineParamName),
                .string(McpConfig.endLineParamName),
                .string(McpConfig.replacementParamName)
            ])
        ])
    )
    
    /// Tool for reading directories
    static let readDirTool = Tool(
        name: McpConfig.readDirToolName,
        description: McpConfig.readDirToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.directoryPathParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                ]),
                McpConfig.fileExtensionParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.fileExtensionParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
        ])
    )
    
    // MARK: - Resource Definitions
    
    /// Resource for accessing Xcode projects
    static let xcodeProjResource = Resource(
        name: McpConfig.xcodeProjResourceName,
        uri: McpConfig.xcodeProjResourceURI,
        description: McpConfig.xcodeProjResourceDesc
    )
    
    /// Resource for accessing file contents
    static let fileContentsResource = Resource(
        name: McpConfig.fileContentsResourceName,
        uri: McpConfig.fileContentsResourceURI,
        description: McpConfig.fileContentsResourceDesc
    )
    
    /// Resource for accessing build results
    static let buildResultsResource = Resource(
        name: McpConfig.buildResultsResourceName,
        uri: McpConfig.buildResultsResourceURI,
        description: McpConfig.buildResultsResourceDesc
    )
    
    // MARK: - Prompt Definitions
    
    /// Prompt for building a project
    static let buildPrompt = Prompt(
        name: McpConfig.buildPromptName,
        description: McpConfig.buildPromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
        ]
    )
    
    /// Prompt for running a project
    static let runPrompt = Prompt(
        name: McpConfig.runPromptName,
        description: McpConfig.runPromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
        ]
    )
    
    /// Prompt for analyzing code
    static let analyzeCodePrompt = Prompt(
        name: McpConfig.analyzeCodePromptName,
        description: McpConfig.analyzeCodePromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: McpConfig.includeSnippetArgName, description: McpConfig.includeSnippetArgDesc, required: false)
        ]
    )
    
    // MARK: - Collections
    
    /// All available tools
    static let allTools = [
        xcfTool, listToolsTool, quickHelpTool, detailedHelpTool, snippetTool, analyzerTool, readDirTool,
        writeFileTool, readFileTool, cdDirTool,
        editFileTool, deleteFileTool,
        addDirTool, rmDirTool,
        openDocTool, createDocTool, readDocTool, saveDocTool, editDocTool,
    ]
    
    /// All available resources
    static let allResources = [xcodeProjResource, fileContentsResource, buildResultsResource]
    
    /// All available prompts
    static let allPrompts = [buildPrompt, runPrompt, analyzeCodePrompt]
    
    // MARK: - Formatting Methods
    
    /// Returns a formatted string listing all available tools
    static func getToolsList() -> String {
        var result = McpConfig.availableTools
        
        for tool in allTools {
            result += String(format: McpConfig.toolListFormat, tool.name, tool.description)
        }
        
        return result
    }
    
    /// Returns a formatted string listing all available resources
    static func getResourcesList() -> String {
        var result = McpConfig.availableResources
        
        for resource in allResources {
            result += String(format: McpConfig.resourceListFormat, 
                             resource.name, 
                             resource.uri, 
                             resource.description ?? "")
        }
        
        return result
    }
    
    /// Returns a formatted string listing all available prompts
    static func getPromptsList() -> String {
        var result = McpConfig.availablePrompts
        
        for prompt in allPrompts {
            result += String(format: McpConfig.promptListFormat, 
                             prompt.name, 
                             prompt.description ?? "")
        }
        
        return result
    }
    
    // MARK: - Server Configuration
    
    /// Configures and starts the MCP server
    /// - Returns: The configured MCP server
    /// - Throws: Errors from server initialization or start
    static func configureMcpServer() async throws -> Server {
        let projectManager = XcfXcodeProjectManager.shared
        
        // Initialize the project manager
        projectManager.initialize()
        
        // If no project was set from environment, try to select one
        if projectManager.currentProject == nil {
            projectManager.currentProject = await XcfActionHandler.selectProject()
        }

        // Set up the server with enhanced capabilities
        let server = Server(
            name: McpConfig.serverName,
            version: McpConfig.serverVersion,
            capabilities: .init(
                prompts: .init(listChanged: true),
                resources: .init(subscribe: true, listChanged: true),
                tools: .init(listChanged: true)
            )
        )

        // Configure the transport
        let transport = StdioTransport()
        
        do {
            // Start the server with the configured transport
            try await server.start(transport: transport)
            
            // Register all handlers
            await registerHandlers(server: server)
            
            return server
        } catch {
            print(String(format: McpConfig.errorStartingServer, error.localizedDescription))
            throw error
        }
    }
    
    // MARK: - Handler Registration
    
    /// Registers all method handlers with the server
    /// - Parameter server: The MCP server to register handlers with
    private static func registerHandlers(server: Server) async {
        await registerToolsHandlers(server: server)
        await registerResourcesHandlers(server: server)
        await registerPromptsHandlers(server: server)
    }
    
    /// Registers handlers for tool-related methods
    /// - Parameter server: The MCP server to register handlers with
    private static func registerToolsHandlers(server: Server) async {
        // Handle tool listing
        await server.withMethodHandler(ListTools.self) { _ in
            ListTools.Result(tools: allTools)
        }
        
        // Handle tool calls
        await server.withMethodHandler(CallTool.self) { params in
            try await handleToolCall(params)
        }
    }
    
    /// Registers handlers for resource-related methods
    /// - Parameter server: The MCP server to register handlers with
    private static func registerResourcesHandlers(server: Server) async {
        // Handle resource listing
        await server.withMethodHandler(ListResources.self) { _ in
            ListResources.Result(resources: allResources)
        }
        
        // Handle resource retrieval
        await server.withMethodHandler(ReadResource.self) { params in
            try await handleResourceRequest(params)
        }
    }
    
    /// Registers handlers for prompt-related methods
    /// - Parameter server: The MCP server to register handlers with
    private static func registerPromptsHandlers(server: Server) async {
        // Handle prompt listing
        await server.withMethodHandler(ListPrompts.self) { _ in
            ListPrompts.Result(prompts: allPrompts)
        }
        
        // Handle prompt retrieval
        await server.withMethodHandler(GetPrompt.self) { params in
            try handlePromptRequest(params)
        }
    }
    
    // MARK: - Tool Call Handling
    
    /// Handles a tool call request
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    /// - Throws: Invalid parameter errors
    private static func handleToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        switch params.name {
        case McpConfig.listToolsName:
            return CallTool.Result(content: [.text(getToolsList())])
            
        case McpConfig.xcfToolName:
            return try await handleXcfToolCall(params)
            
        case McpConfig.snippetToolName:
            return try handleSnippetToolCall(params)
            
        case McpConfig.analyzerToolName:
            return try handleAnalyzerToolCall(params)
            
        case McpConfig.quickHelpToolName:
            return handleQuickHelpToolCall(params)
            
        case McpConfig.detailedHelpToolName:
            return handleDetailedHelpToolCall(params)
            
        case McpConfig.writeFileToolName:
            return try handleWriteFileToolCall(params)
            
        case McpConfig.readFileToolName:
            return try handleReadFileToolCall(params)
            
        case McpConfig.cdDirToolName:
            return try handleCdDirToolCall(params)
            
        case McpConfig.editFileToolName:
            return try handleEditFileToolCall(params)
            
        case McpConfig.deleteFileToolName:
            return try handleDeleteFileToolCall(params)
            
        case McpConfig.addDirToolName:
            return try handleAddDirToolCall(params)
            
        case McpConfig.rmDirToolName:
            return try handleRmDirToolCall(params)
            
        case McpConfig.openDocToolName:
            return try handleOpenDocToolCall(params)
            
        case McpConfig.createDocToolName:
            return try handleCreateDocToolCall(params)
            
        case McpConfig.readDocToolName:
            return try handleReadDocToolCall(params)
            
        case McpConfig.saveDocToolName:
            return try handleSaveDocToolCall(params)
            
        case McpConfig.editDocToolName:
            return try handleEditDocToolCall(params)
            
        case McpConfig.readDirToolName:
            return try handleReadDirToolCall(params)
            
        default:
            throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
        }
    }
    
    /// Handles a call to the xcf tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the xcf tool call
    /// - Throws: Error if action is missing
    private static func handleXcfToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        if let arguments = params.arguments,
           let action = arguments[McpConfig.actionParamName]?.stringValue {
            print(String(format: McpConfig.actionFound, action))
            return CallTool.Result(content: [.text(await XcfActionHandler.handleAction(action: action))])
        } else {
            print(McpConfig.noActionFound)
            // If no action specified, return the help information
            return CallTool.Result(content: [.text(await XcfActionHandler.handleAction(action: Actions.help))])
        }
    }
    
    /// Handles a call to the snippet tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the snippet tool call
    /// - Throws: Error if filePath is missing
    private static func handleSnippetToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        let entireFile = arguments[McpConfig.entireFileParamName]?.boolValue ?? false
        let startLine = arguments[McpConfig.startLineParamName]?.intValue
        let endLine = arguments[McpConfig.endLineParamName]?.intValue
        
        return handleCodeSnippet(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
    
    /// Handles a call to the quick help tool
    private static func handleQuickHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(McpConfig.helpText)])
    }

    /// Handles a call to the detailed help tool
    private static func handleDetailedHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(getDetailedHelpText())])
    }

    /// Returns detailed help text for all tools
    private static func getDetailedHelpText() -> String {
        var help = "XCF Tool Commands:\n\n"
        help += "File Operations:\n"
        help += "  write_file <path> <content>  - Write content to a file\n"
        help += "  read_file <path>            - Read content from a file\n"
        help += "  edit_file <path> <start> <end> <content> - Edit specific lines in a file\n"
        help += "  delete_file <path>          - Delete a file\n\n"
        help += "Directory Operations:\n"
        help += "  cd_dir <path>               - Change current directory\n"
        help += "  add_dir <path>              - Create a new directory\n"
        help += "  rm_dir <path>               - Remove a directory\n\n"
        help += "Help Commands:\n"
        help += "  ?                           - Quick help for common commands\n"
        help += "  help                       - This detailed help message\n\n"
        help += "Other Tools:\n"
        help += "  snippet                     - Extract code snippets from files\n"
        help += "  analyzer                    - Analyze Swift code\n"
        return help
    }
    
    /// Handles a call to the write file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the write file tool call
    /// - Throws: Error if filePath or content is missing
    private static func handleWriteFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Get content as the second argument or from the named parameter
        let content: String
        if let namedContent = arguments[McpConfig.contentParamName]?.stringValue {
            content = namedContent
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 2, let secondArg = arguments[keys[1]]?.stringValue {
                content = secondArg
            } else {
                return CallTool.Result(content: [.text("Missing content parameter")])
            }
        }
        
        do {
            try XcfFileManager.writeFile(content: content, to: filePath)
            return CallTool.Result(content: [.text(McpConfig.fileWrittenSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorWritingFile, error.localizedDescription))])
        }
    }

    /// Handles a call to the read file tool
    private static func handleReadFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        do {
            let fileContents = try XcfFileManager.readFile(at: filePath)
            return CallTool.Result(content: [.text(fileContents)])
        } catch let error as NSError {
            return CallTool.Result(content: [.text(error.localizedDescription)])
        }
    }

    /// Handles a call to the change directory tool
    private static func handleCdDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingDirectoryPathParamError)])
        }
        
        do {
            try XcfFileManager.changeDirectory(to: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryChangedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorChangingDirectory, error.localizedDescription))])
        }
    }

    /// Handles a call to the edit file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the edit file tool call
    /// - Throws: Error if filePath, start line, end line, or replacement content is missing
    private static func handleEditFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Get startLine as the second argument or from the named parameter
        let startLine: Int
        if let namedStartLine = arguments[McpConfig.startLineParamName]?.intValue {
            startLine = namedStartLine
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 2, let secondArg = arguments[keys[1]]?.stringValue, let line = Int(secondArg) {
                startLine = line
            } else {
                return CallTool.Result(content: [.text("Missing startLine parameter")])
            }
        }
        
        // Get endLine as the third argument or from the named parameter
        let endLine: Int
        if let namedEndLine = arguments[McpConfig.endLineParamName]?.intValue {
            endLine = namedEndLine
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 3, let thirdArg = arguments[keys[2]]?.stringValue, let line = Int(thirdArg) {
                endLine = line
            } else {
                return CallTool.Result(content: [.text("Missing endLine parameter")])
            }
        }
        
        // Get replacement content as the fourth argument or from the named parameter
        let replacementContent: String
        if let namedReplacement = arguments[McpConfig.replacementParamName]?.stringValue {
            replacementContent = namedReplacement
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 4, let fourthArg = arguments[keys[3]]?.stringValue {
                replacementContent = fourthArg
            } else {
                return CallTool.Result(content: [.text("Missing replacement content parameter")])
            }
        }
        
        do {
            try XcfFileManager.editFile(at: filePath, startLine: startLine, endLine: endLine, replacementContent: replacementContent)
            return CallTool.Result(content: [.text(McpConfig.fileEditedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorEditingFile, error.localizedDescription))])
        }
    }

    /// Handles a call to the delete file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the delete file tool call
    /// - Throws: Error if filePath is missing
    private static func handleDeleteFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        do {
            try XcfFileManager.deleteFile(at: filePath)
            return CallTool.Result(content: [.text(McpConfig.fileDeletedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorDeletingFile, error.localizedDescription))])
        }
    }

    /// Handles a call to the add directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the add directory tool call
    /// - Throws: Error if directory path is missing
    private static func handleAddDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingDirectoryPathParamError)])
        }
        
        do {
            try XcfFileManager.createDirectory(at: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryCreatedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorCreatingDirectory, error.localizedDescription))])
        }
    }

    /// Handles a call to the remove directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the remove directory tool call
    /// - Throws: Error if directory path is missing
    private static func handleRmDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingDirectoryPathParamError)])
        }
        
        do {
            try XcfFileManager.removeDirectory(at: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryRemovedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorRemovingDirectory, error.localizedDescription))])
        }
    }
    
    // MARK: - Resource Request Handling
    
    /// Handles a resource request
    /// - Parameter params: The parameters for the resource request
    /// - Returns: The result of the resource request
    /// - Throws: Invalid parameter errors or resource access errors
    private static func handleResourceRequest(_ params: ReadResource.Parameters) async throws -> ReadResource.Result {
        switch params.uri {
        case McpConfig.xcodeProjResourceURI:
            return try await handleXcodeProjectsResource()
            
        case McpConfig.fileContentsResourceURI:
            return try handleFileContentsResource(uri: params.uri)
            
        case McpConfig.buildResultsResourceURI:
            return try await handleBuildResultsResource()
            
        default:
            throw MCPError.invalidParams(String(format: McpConfig.unknownResourceUriError, params.uri))
        }
    }
    
    /// Handles a request for the Xcode projects resource
    /// - Returns: The Xcode projects resource content
    private static func handleXcodeProjectsResource() async throws -> ReadResource.Result {
        let projects = await XcfActionHandler.getSortedXcodeProjects()
        let content = Resource.Content.text(
            projects.joined(separator: McpConfig.newLineSeparator),
            uri: McpConfig.xcodeProjResourceURI
        )
        return ReadResource.Result(contents: [content])
    }
    
    /// Handles a request for the build results resource
    /// - Returns: The build results resource content
    /// - Throws: Error if no project is selected
    private static func handleBuildResultsResource() async throws -> ReadResource.Result {
        guard let currentProject = await XcfActionHandler.getCurrentProject() else {
            throw MCPError.invalidParams(ErrorMessages.noProjectSelected)
        }
        
        let buildResults = XcfScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        let content = Resource.Content.text(
            buildResults,
            uri: McpConfig.buildResultsResourceURI
        )
        return ReadResource.Result(contents: [content])
    }
    
    // MARK: - Prompt Request Handling
    
    /// Handles a prompt request
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The result of the prompt request
    /// - Throws: Invalid parameter errors
    private static func handlePromptRequest(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        switch params.name {
        case McpConfig.buildPromptName:
            return handleBuildPrompt(params)
            
        case McpConfig.runPromptName:
            return handleRunPrompt(params)
            
        case McpConfig.analyzeCodePromptName:
            return try handleAnalyzeCodePrompt(params)
            
        default:
            throw MCPError.invalidParams(String(format: McpConfig.unknownPromptNameError, params.name))
        }
    }
    
    /// Handles a request for the build project prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The build project prompt messages
    private static func handleBuildPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? McpConfig.projectPathPlaceholder
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: String(format: McpConfig.buildProjectTemplate, projectPath)))
        ]
        
        return GetPrompt.Result(description: McpConfig.buildProjectResultDesc, messages: messages)
    }
    
    /// Handles a request for the run project prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The run project prompt messages
    private static func handleRunPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? McpConfig.projectPathPlaceholder
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: String(format: McpConfig.runProjectTemplate, projectPath)))
        ]
        
        return GetPrompt.Result(description: McpConfig.runProjectResultDesc, messages: messages)
    }
    
    /// Handles a request for the analyze code prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The analyze code prompt messages
    /// - Throws: File access errors
    private static func handleAnalyzeCodePrompt(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        // Get file path from arguments or use placeholder
        let filePath = params.arguments?[McpConfig.filePathArgName]?.stringValue ?? McpConfig.filePathPlaceholder
        let includeSnippet = params.arguments?[McpConfig.includeSnippetArgName]?.boolValue ?? false
        
        // Create the base message
        let baseMessage = Prompt.Message(
            role: .user,
            content: .text(text: String(format: McpConfig.analyzeCodeTemplate, filePath))
        )
        
        var messages: [Prompt.Message] = [baseMessage]
        
        // Add code snippet if requested
        if includeSnippet {
            if let snippetMessage = try? createCodeSnippetMessage(filePath: filePath) {
                messages.append(snippetMessage)
            }
            // If snippet creation fails, we still return the base message
        }
        
        return GetPrompt.Result(description: McpConfig.analyzeCodeResultDesc, messages: messages)
    }
    
    /// Creates a message containing a code snippet
    /// - Parameter filePath: Path to the file to extract code from
    /// - Returns: A message containing the code snippet
    /// - Throws: File access errors
    private static func createCodeSnippetMessage(filePath: String) throws -> Prompt.Message {
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        let language = CaptureSnippet.determineLanguage(from: filePath)
        let resourceUri = "\(McpConfig.fileContentsResourceURI)/\(filePath)"
        
        return Prompt.Message(
            role: .user,
            content: .resource(
                uri: resourceUri,
                mimeType: McpConfig.plainTextMimeType,
                text: String(format: McpConfig.codeBlockFormat, language, fileContents),
                blob: nil
            )
        )
    }
    
    /// Handles code snippet extraction
    /// - Parameters:
    ///   - filePath: Path to the file to extract from
    ///   - entireFile: Whether to extract the entire file
    ///   - startLine: The line to start extraction from
    ///   - endLine: The line to end extraction at
    /// - Returns: The extracted code snippet
    private static func handleCodeSnippet(filePath: String, entireFile: Bool, startLine: Int? = nil, endLine: Int? = nil) -> CallTool.Result {
        // Resolve the file path using multiple strategies
        let (resolvedPath, warning) = CaptureSnippet.resolveFilePath(filePath)
        
        // Validate file path - use the resolved path
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, "File not found. Tried searching for \(filePath) in multiple locations."))])
        }
        
        // Add warning message if there is one
        var warningText = ""
        if !warning.isEmpty {
            warningText = warning + Format.newLine + Format.newLine
        }
        
        if entireFile {
            return handleEntireFileSnippet(filePath: resolvedPath, warning: warningText)
        } else if let startLine = startLine, let endLine = endLine {
            return handleLineRangeSnippet(filePath: resolvedPath, startLine: startLine, endLine: endLine, warning: warningText)
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
        }
    }
    
    /// Handles extracting an entire file as a code snippet
    /// - Parameter filePath: Path to the file to extract
    /// - Returns: The extracted code snippet
    private static func handleEntireFileSnippet(filePath: String, warning: String = "") -> CallTool.Result {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let language = CaptureSnippet.determineLanguage(from: filePath)
            return CallTool.Result(content: [.text(warning + String(format: McpConfig.codeBlockFormat, language, fileContents))])
        } catch {
            return CallTool.Result(content: [.text(warning + String(format: ErrorMessages.errorReadingFile, error.localizedDescription))])
        }
    }
    
    /// Handles extracting a range of lines as a code snippet
    /// - Parameters:
    ///   - filePath: Path to the file to extract from
    ///   - startLine: The line to start extraction from
    ///   - endLine: The line to end extraction at
    /// - Returns: The extracted code snippet
    private static func handleLineRangeSnippet(filePath: String, startLine: Int, endLine: Int, warning: String = "") -> CallTool.Result {
        let (snippet, language) = CaptureSnippet.getCodeSnippet(
            filePath: filePath,
            startLine: startLine,
            endLine: endLine
        )
        
        return CallTool.Result(content: [.text(warning + String(format: McpConfig.codeBlockFormat, language, snippet))])
    }
    
    /// Handles extracting a code snippet for the analyzer tool
    /// - Parameters:
    ///   - filePath: Path to the file to extract from
    ///   - entireFile: Whether to extract the entire file
    ///   - startLine: The line to start extraction from
    ///   - endLine: The line to end extraction at
    /// - Returns: The extracted code snippet
    private static func handleAnalyzerCodeSnippet(filePath: String, entireFile: Bool, startLine: Int? = nil, endLine: Int? = nil) -> CallTool.Result {
        // Use SwiftAnalyzer to analyze the code
        let (analysisResult, language) = SwiftAnalyzer.analyzeCode(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
        
        // Format the result based on the language
        if language == "markdown" {
            // Markdown output doesn't need code block formatting
            return CallTool.Result(content: [.text(analysisResult)])
        } else {
            // Format as code block
            return CallTool.Result(content: [.text(String(format: McpConfig.codeBlockFormat, language, analysisResult))])
        }
    }
    
    /// Handles a call to the analyzer tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the analyzer tool call
    /// - Throws: Error if filePath is missing
    private static func handleAnalyzerToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        let entireFile = arguments[McpConfig.entireFileParamName]?.boolValue ?? false
        let startLine = arguments[McpConfig.startLineParamName]?.intValue
        let endLine = arguments[McpConfig.endLineParamName]?.intValue
        
        return handleAnalyzerCodeSnippet(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
    
    // MARK: - Utility Methods
    
    /// Extracts a file path from a URI query string
    /// - Parameter uri: The URI to extract the file path from
    /// - Returns: The extracted file path, or nil if not found
    private static func extractFilePathFromUri(_ uri: String) -> String? {
        let uriComponents = uri.components(separatedBy: "?")
        guard uriComponents.count > 1,
              let queryItems = URLComponents(string: "?" + uriComponents[1])?.queryItems,
              let filePathItem = queryItems.first(where: { $0.name == McpConfig.filePathQueryParam }),
              let filePath = filePathItem.value,
              !filePath.isEmpty else {
            return nil
        }
        return filePath
    }
    
    /// Handles a request for the file contents resource
    /// - Parameter uri: The URI of the resource request
    /// - Returns: The file contents resource
    /// - Throws: Invalid parameter errors or file access errors
    private static func handleFileContentsResource(uri: String) throws -> ReadResource.Result {
        guard let filePath = extractFilePathFromUri(uri) else {
            throw MCPError.invalidParams(McpConfig.missingFilePathParamError)
        }
        
        do {
            let fileContents = try XcfFileManager.readFile(at: filePath)
            let content = Resource.Content.text(
                fileContents,
                uri: "\(McpConfig.fileContentsResourceURI)/\(filePath)",
                mimeType: McpConfig.plainTextMimeType
            )
            return ReadResource.Result(contents: [content])
        } catch let error as NSError {
            throw MCPError.invalidParams(error.localizedDescription)
        }
    }

    /// Handles a call to the read directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the read directory tool call
    /// - Throws: Error if directory cannot be read
    private static func handleReadDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            // If no arguments, try to use currentFolder
            guard let currentFolder = XcfXcodeProjectManager.shared.currentFolder else {
                return CallTool.Result(content: [.text("No directory path specified and no current folder is set. Please select a project first or specify a directory path.")])
            }
            
            do {
                let filePaths = try XcfFileManager.readDirectory(at: currentFolder, fileExtension: nil)
                let content = filePaths.joined(separator: McpConfig.newLineSeparator)
                return CallTool.Result(content: [.text(content)])
            } catch {
                return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingDirectory, error.localizedDescription))])
            }
        }
        
        // Try to get directoryPath from arguments in two ways:
        // 1. As a named parameter (directoryPath=...)
        // 2. As a direct argument (first argument after command)
        let directoryPath: String
        if let namedPath = arguments[McpConfig.directoryPathParamName]?.stringValue {
            directoryPath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            // If first argument is '.' or empty, use currentFolder
            if firstArg.isEmpty || firstArg == "." {
                guard let currentFolder = XcfXcodeProjectManager.shared.currentFolder else {
                    return CallTool.Result(content: [.text("No current folder is set. Please select a project first.")])
                }
                directoryPath = currentFolder
            } else {
                directoryPath = firstArg
            }
        } else if let cf = XcfXcodeProjectManager.shared.currentFolder {
            // Use current folder if no path is specified
            directoryPath = cf
        } else {
            return CallTool.Result(content: [.text("No directory path specified and no current folder is set. Please select a project first or specify a directory path.")])
        }
        
        // Get fileExtension as the second argument or from the named parameter
        let fileExtension: String?
        if let namedExt = arguments[McpConfig.fileExtensionParamName]?.stringValue {
            fileExtension = namedExt
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 2, let secondArg = arguments[keys[1]]?.stringValue {
                fileExtension = secondArg
            } else {
                fileExtension = nil
            }
        }
        
        do {
            let filePaths = try XcfFileManager.readDirectory(at: directoryPath, fileExtension: fileExtension)
            let content = filePaths.joined(separator: McpConfig.newLineSeparator)
            return CallTool.Result(content: [.text(content)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingDirectory, error.localizedDescription))])
        }
    }

    /// Handles a call to the create directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the create directory tool call
    /// - Throws: MCPError for invalid parameters or FileManager errors
    private static func handleCreateDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            throw MCPError.invalidParams(McpConfig.missingDirectoryPathParamError)
        }
        
        do {
            try XcfFileManager.createDirectory(at: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryCreatedSuccessfully)])
        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDirectory, error.localizedDescription))
        }
    }

    /// Handles a call to the create file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the create file tool call
    /// - Throws: Error if filePath or content is missing
    private static func handleCreateFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue,
              let content = arguments[McpConfig.contentParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        do {
            try XcfFileManager.createFile(at: filePath, content: content)
            return CallTool.Result(content: [.text(McpConfig.fileCreatedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorCreatingFile, error.localizedDescription))])
        }
    }

    /// Handles opening a document in Xcode
    private static func handleOpenDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        if XcfScript.openSwiftDocument(filePath: filePath) {
            return CallTool.Result(content: [.text(McpConfig.documentOpenedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorOpeningFile, filePath))])
        }
    }

    /// Handles creating a document in Xcode
    private static func handleCreateDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        let content = arguments[McpConfig.contentParamName]?.stringValue ?? ""
        
        if XcfScript.createSwiftDocumentWithScriptingBridge(filePath: filePath, content: content) {
            return CallTool.Result(content: [.text(McpConfig.documentCreatedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorCreatingFile, filePath))])
        }
    }

    /// Handles reading a document from Xcode
    private static func handleReadDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        if let content = XcfScript.readSwiftDocumentWithScriptingBridge(filePath: filePath) {
            return CallTool.Result(content: [.text(content)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, filePath))])
        }
    }

    /// Handles saving a document in Xcode
    private static func handleSaveDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        if XcfScript.writeSwiftDocumentWithScriptingBridge(filePath: filePath, content: "") {
            return CallTool.Result(content: [.text(McpConfig.documentSavedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorWritingFile, filePath))])
        }
    }

    /// Handles editing a document in Xcode
    private static func handleEditDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue,
              let startLine = arguments[McpConfig.startLineParamName]?.intValue,
              let endLine = arguments[McpConfig.endLineParamName]?.intValue,
              let replacement = arguments[McpConfig.replacementParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
        }
        
        if XcfScript.editSwiftDocumentWithScriptingBridge(filePath: filePath, startLine: startLine, endLine: endLine, replacement: replacement) {
            return CallTool.Result(content: [.text(McpConfig.documentEditedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorEditingFile, filePath))])
        }
    }
} 