import Foundation
import MCP
import MultiLineDiff

typealias StringIndex = String.Index

// MARK: - MCP Handlers

class XcfMcpHandlers {
    
    // MARK: - Handler Registration
    
    /// Registers all method handlers with the server
    static func registerAllHandlers(server: Server) async {
        await registerToolsHandlers(server: server)
        await registerResourcesHandlers(server: server)
        await registerPromptsHandlers(server: server)
    }

    /// Registers handlers for tool-related methods
    private static func registerToolsHandlers(server: Server) async {
        // Handle tool listing
        await server.withMethodHandler(ListTools.self) { _ in
            ListTools.Result(tools: XcfMcpTools.getAllTools())
        }
        
        // Handle tool calls - delegate to specialized handler
        await server.withMethodHandler(CallTool.self) { params in
            try await XcfMcpToolCallHandlers.handleToolCall(params)
        }
    }

    /// Registers handlers for resource-related methods
    private static func registerResourcesHandlers(server: Server) async {
        // Handle resource listing
        await server.withMethodHandler(ListResources.self) { _ in
            ListResources.Result(resources: XcfMcpResources.getAllResources())
        }
        
        // Handle resource retrieval - delegate to specialized handler
        await server.withMethodHandler(ReadResource.self) { params in
            try await XcfMcpResourceHandlers.handleResourceRequest(params)
        }
    }

    /// Registers handlers for prompt-related methods
    private static func registerPromptsHandlers(server: Server) async {
        // Handle prompt listing
        await server.withMethodHandler(ListPrompts.self) { _ in
            ListPrompts.Result(prompts: XcfMcpPrompts.getAllPrompts())
        }
        
        // Handle prompt retrieval - delegate to specialized handler
        await server.withMethodHandler(GetPrompt.self) { params in
            try XcfMcpPromptHandlers.handlePromptRequest(params)
        }
    }
    
    // MARK: - Utility Methods
    
    /// Extracts a file path from a URI query string
    static func extractFilePathFromUri(_ uri: String) -> String? {
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
    
    /// Generate Tool List
    static func getToolsList() -> String {
        var result = McpConfig.availableTools
        
        for tool in XcfMcpTools.getAllTools() {
            result += String(format: McpConfig.toolListFormat, tool.name, tool.description)
        }
        
        return result
    }
    
    static func getResourcesList() -> String {
        var result = McpConfig.availableResources
        
        for resource in XcfMcpResources.getAllResources() {
            result += String(format: McpConfig.resourceListFormat,
                             resource.name,
                             resource.uri,
                             resource.description ?? "")
        }
        
        return result
    }
    
    static func getPromptsList() -> String {
        var result = McpConfig.availablePrompts
        
        for prompt in XcfMcpPrompts.getAllPrompts() {
            result += String(format: McpConfig.promptListFormat,
                             prompt.name,
                             prompt.description ?? "")
        }
        
        return result
    }
} 