//
//  XcfMcpRegistration.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//

// MARK: - Handler Registration

import MCP

extension XcfMcpServer {
    /// Registers all method handlers with the server
    /// - Parameter server: The MCP server to register handlers with
    static func registerHandlers(server: Server) async {
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

    /// A custom method handler for string-based methods
    struct MethodHandler {
        let name: String
        let handler: (CallTool.Parameters) -> CallTool.Result
    }
}
