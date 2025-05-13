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
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for displaying help information
    static let helpTool = Tool(
        name: McpConfig.helpToolName,
        description: McpConfig.helpToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
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
    static let allTools = [xcfTool, listToolsTool, snippetTool, helpTool]
    
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
        currentProject = await XcfActionHandler.selectProject()

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
            
        case McpConfig.helpToolName:
            return handleHelpToolCall(params)
            
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
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
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
    
    /// Handles a call to the help tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the help tool call
    private static func handleHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        // Return the help text directly
        return CallTool.Result(content: [.text(McpConfig.helpText)])
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
        
        // Validate file exists before attempting to read
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            throw MCPError.invalidParams("File does not exist: \(filePath)")
        }
        
        // Check file size to avoid loading extremely large files
        guard let attributes = try? fileManager.attributesOfItem(atPath: filePath),
              let fileSize = attributes[.size] as? UInt64 else {
            throw MCPError.invalidParams("Could not determine file size: \(filePath)")
        }
        
        // Set a reasonable size limit (10MB)
        let sizeLimit: UInt64 = 10 * 1024 * 1024
        guard fileSize < sizeLimit else {
            throw MCPError.invalidParams("File is too large (> 10MB): \(filePath)")
        }
        
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let content = Resource.Content.text(
                fileContents,
                uri: "\(McpConfig.fileContentsResourceURI)/\(filePath)",
                mimeType: McpConfig.plainTextMimeType
            )
            return ReadResource.Result(contents: [content])
        } catch let error as NSError {
            // More specific error handling based on the error code
            if error.domain == NSCocoaErrorDomain {
                switch error.code {
                case NSFileReadNoSuchFileError:
                    throw MCPError.invalidParams("File not found: \(filePath)")
                case NSFileReadNoPermissionError:
                    throw MCPError.invalidParams("Permission denied to read file: \(filePath)")
                case NSFileReadCorruptFileError:
                    throw MCPError.invalidParams("File is corrupt: \(filePath)")
                default:
                    throw MCPError.invalidParams(String(format: ErrorMessages.errorReadingFile, error.localizedDescription))
                }
            } else {
                throw MCPError.invalidParams(String(format: ErrorMessages.errorReadingFile, error.localizedDescription))
            }
        }
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
} 
