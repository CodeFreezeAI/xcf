//
//  XcfMcpServer.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation
import MCP

/// McpServer handles all MCP protocol interactions for the xcf tool.
/// It uses a composition-based architecture to organize tools, resources, and prompts.
class XcfMcpServer {
    static var XcfScript = XcfSwiftScript.shared
    
    // Component managers
    private let toolManager: XcfMcpToolManager
    private let resourceManager: XcfMcpResourceManager
    private let promptManager: XcfMcpPromptManager
    private let handlerRegistrar: XcfMcpHandlerRegistrar
    
    /// Initialize with dependencies (defaults to singleton instances)
    init(toolManager: XcfMcpToolManager = .shared,
         resourceManager: XcfMcpResourceManager = .shared,
         promptManager: XcfMcpPromptManager = .shared,
         handlerRegistrar: XcfMcpHandlerRegistrar = .shared) {
        self.toolManager = toolManager
        self.resourceManager = resourceManager
        self.promptManager = promptManager
        self.handlerRegistrar = handlerRegistrar
    }
    
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
            
            // Register all handlers using the handler registrar
            await XcfMcpHandlerRegistrar.shared.registerHandlers(server: server)
            
            return server
        } catch {
            print(String(format: McpConfig.errorStartingServer, error.localizedDescription))
            throw error
        }
    }
} 
