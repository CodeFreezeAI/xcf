// XcfMcpHandlerRegistrar.swift
// xcf
//
// Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

/// Registers handlers for MCP methods
class XcfMcpHandlerRegistrar: HandlerRegistrar {
    static let shared = XcfMcpHandlerRegistrar()
    
    private let toolManager: XcfMcpToolManager
    private let resourceManager: XcfMcpResourceManager
    private let promptManager: XcfMcpPromptManager
    
    init(toolManager: XcfMcpToolManager = .shared,
         resourceManager: XcfMcpResourceManager = .shared,
         promptManager: XcfMcpPromptManager = .shared) {
        self.toolManager = toolManager
        self.resourceManager = resourceManager
        self.promptManager = promptManager
    }
    
    /// Registers all method handlers with the server
    /// - Parameter server: The MCP server to register handlers with
    func registerHandlers(server: Server) async {
        await registerToolsHandlers(server: server)
        await registerResourcesHandlers(server: server)
        await registerPromptsHandlers(server: server)
    }
    
    /// Registers handlers for tool-related methods
    /// - Parameter server: The MCP server to register handlers with
    private func registerToolsHandlers(server: Server) async {
        // Handle tool listing
        await server.withMethodHandler(ListTools.self) { _ in
            ListTools.Result(tools: self.toolManager.tools)
        }
        
        // Handle tool calls
        await server.withMethodHandler(CallTool.self) { params in
            try await self.toolManager.handleToolCall(params)
        }
    }
    
    /// Registers handlers for resource-related methods
    /// - Parameter server: The MCP server to register handlers with
    private func registerResourcesHandlers(server: Server) async {
        // Handle resource listing
        await server.withMethodHandler(ListResources.self) { _ in
            ListResources.Result(resources: self.resourceManager.resources)
        }
        
        // Handle resource retrieval
        await server.withMethodHandler(ReadResource.self) { params in
            try await self.resourceManager.handleResourceRequest(params)
        }
    }
    
    /// Registers handlers for prompt-related methods
    /// - Parameter server: The MCP server to register handlers with
    private func registerPromptsHandlers(server: Server) async {
        // Handle prompt listing
        await server.withMethodHandler(ListPrompts.self) { _ in
            ListPrompts.Result(prompts: self.promptManager.prompts)
        }
        
        // Handle prompt retrieval
        await server.withMethodHandler(GetPrompt.self) { params in
            try self.promptManager.handlePromptRequest(params)
        }
    }
} 
