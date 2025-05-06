//
//  McpServer.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation
import MCP

// Server configuration
struct McpServer {
    // Define our tools
    static let listToolsTool = Tool(
        name: McpConfig.listToolsName,
        description: McpConfig.listToolsDesc,
        inputSchema: .object([
            "type": .string(McpConfig.objectType)
        ])
    )

    static let xcfTool = Tool(
        name: McpConfig.xcfToolName,
        description: McpConfig.xcfToolDesc,
        inputSchema: .object([
            "type": .string(McpConfig.objectType),
            "properties": .object([
                McpConfig.directiveParamName: .object([
                    "type": .string(McpConfig.stringType),
                    "description": .string(McpConfig.directiveParamDesc)
                ])
            ]),
            "required": .array([.string(McpConfig.directiveParamName)])
        ])
    )
    
    // Get all available tools
    static let allTools = [xcfTool, listToolsTool]
    
    // Get tools list as a formatted string
    static func getToolsList() -> String {
        var result = McpConfig.availableTools
        
        for tool in allTools {
            result += String(format: McpConfig.toolListFormat, tool.name, tool.description)
        }
        
        return result
    }
    
    // Configure and start the MCP server
    static func configureMcpServer() async throws -> Server {
        // Set up the server
        let server = Server(
            name: McpConfig.serverName,
            version: McpConfig.serverVersion,
            capabilities: .init(tools: .init(listChanged: false))
        )

        // Configure the transport
        let transport = StdioTransport()
        try await server.start(transport: transport)
        
        // Register handlers
        await registerHandlers(server: server)
        
        return server
    }
    
    // Register all the handlers for the server
    private static func registerHandlers(server: Server) async {
        // Handle tool listing
        await server.withMethodHandler(ListTools.self) { params in
            ListTools.Result(tools: allTools)
        }

        // Handle tool calls
        await server.withMethodHandler(CallTool.self) { params in
            switch params.name {
            case McpConfig.listToolsName:
                return CallTool.Result(content: [.text(getToolsList())])
            case McpConfig.xcfToolName:
                // Extract the directive parameter from arguments
                if let arguments = params.arguments,
                   let directive = arguments[McpConfig.directiveParamName]?.stringValue {
                    print(String(format: McpConfig.directiveFound, directive))
                    return CallTool.Result(content: [.text(await XcfDirectiveHandler.handleDirective(directive: directive))])
                } else {
                    print(McpConfig.noDirectiveFound)
                    // If no directive specified, return the help information
                    return CallTool.Result(content: [.text(await XcfDirectiveHandler.handleDirective(directive: Directives.help))])
                }
            default:
                throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
            }
        }
    }
} 
