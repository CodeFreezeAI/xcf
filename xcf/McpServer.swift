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
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    static let xcfTool = Tool(
        name: McpConfig.xcfToolName,
        description: McpConfig.xcfToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.directiveParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.directiveParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.directiveParamName)])
        ])
    )
    
    // NEW: Add code snippet tool
    static let snippetTool = Tool(
        name: McpConfig.snippetToolName,
        description: McpConfig.snippetToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                "filePath": .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string("Path to the file to extract snippet from")
                ]),
                "startLine": .object([
                    McpConfig.typeKey: .string("integer"),
                    McpConfig.descriptionKey: .string("Starting line number (1-indexed)")
                ]),
                "endLine": .object([
                    McpConfig.typeKey: .string("integer"),
                    McpConfig.descriptionKey: .string("Ending line number (1-indexed)")
                ]),
                "entireFile": .object([
                    McpConfig.typeKey: .string("boolean"),
                    McpConfig.descriptionKey: .string("Set to true to get the entire file content")
                ])
            ]),
            McpConfig.requiredKey: .array([.string("filePath")])
        ])
    )
    
    // Get all available tools
    static let allTools = [xcfTool, listToolsTool, snippetTool]
    
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
            capabilities: .init(tools: .init(listChanged: true))
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
            case McpConfig.snippetToolName:
                if let arguments = params.arguments,
                   let filePath = arguments["filePath"]?.stringValue {
                    
                    let entireFile = arguments["entireFile"]?.boolValue ?? false
                    
                    if entireFile {
                        // If entireFile is true, get the entire file content regardless of other parameters
                        do {
                            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
                            let language = CaptureSnippet.determineLanguage(from: filePath)
                            return CallTool.Result(content: [.text("```\(language)\n\(fileContents)\n```")])
                        } catch {
                            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, error.localizedDescription))])
                        }
                    } else if let startLine = arguments["startLine"]?.intValue,
                              let endLine = arguments["endLine"]?.intValue {
                        // Otherwise use the specified line range
                        let (snippet, language) = CaptureSnippet.getCodeSnippet(
                            filePath: filePath,
                            startLine: startLine,
                            endLine: endLine
                        )
                        
                        return CallTool.Result(content: [.text("```\(language)\n\(snippet)\n```")])
                    } else {
                        return CallTool.Result(content: [.text("Missing required line parameters when entireFile is false")])
                    }
                } else {
                    return CallTool.Result(content: [.text("Missing required filePath parameter for code snippet")])
                }
            default:
                throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
            }
        }
    }
} 
