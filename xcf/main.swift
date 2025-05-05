//
//  main.swift
//  xcf
//
//  Created by Todd Bruss on 5/3/25.
//

import Foundation
import MCP

//Header
print("welcome to xcf in pure swift\nxcodefreeze mcp local server\ncopyright 2025 codefreeze.ai\n")

// Define our tools
let listToolsTool = Tool(
    name: "list_tools",
    description: "Lists all available tools on this server",
    inputSchema: .object([
        "type": .string("object")
    ])
)

let xcfTool = Tool(
    name: "xcf",
    description: "Execute an XCF directive or command",
    inputSchema: .object([
        "type": .string("object"),
        "properties": .object([
            "directive": .object([
                "type": .string("string"),
                "description": .string("The XCF directive to execute")
            ])
        ]),
        "required": .array([.string("directive")])
    ])
)

// Set up the server
let server = Server(
    name: "xcf",
    version: "1.0.0",
    capabilities: .init(tools: .init(listChanged: false))
)

// Configure the transport
let transport = StdioTransport()
try await server.start(transport: transport)

// Get all available tools
let allTools = [xcfTool, listToolsTool]

// Handle tool listing
await server.withMethodHandler(ListTools.self) { params in
    ListTools.Result(tools: allTools)
}

// Handle tool calls
await server.withMethodHandler(CallTool.self) { params in
  
    switch params.name {
    case "list_tools":
        return CallTool.Result(content: [.text(getToolsList(tools: allTools))])
    case "xcf":
        // Add more debugging output
        print("XCF tool called with params: \(params)")
        print("Arguments: \(String(describing: params.arguments))")
        
        // Extract the directive parameter from arguments
        if let arguments = params.arguments,
           let directive = arguments["directive"]?.stringValue {
            print("Directive found: \(directive)")
            return CallTool.Result(content: [.text(await handleXcfDirective(directive: directive))])
        } else {
            print("No directive found, using help")
            // If no directive specified, return the help information
            return CallTool.Result(content: [.text(await handleXcfDirective(directive: "help"))])
        }
    default:
        throw MCPError.invalidParams("Unknown tool: \(params.name)")
    }
}

await server.waitUntilCompleted()

func getToolsList(tools: [Tool]) -> String {
    var result = "Available tools:\n"
    
    for tool in tools {
        result += "- \(tool.name): \(tool.description)\n"
    }
    
    return result
}

var defaultFolderPath = "Monkies"
var currentProject: String?


@MainActor
func handleXcfDirective(directive: String) -> String {
    
    // Convert directive to lowercase for case-insensitive matching
    let lowercasedDirective = directive.lowercased()
    let selectProject = "select project "
    let listProjectsIn = "list projects in "
    switch lowercasedDirective {
    case "xcf":
        return "All systems operational."
    case "help", "xcf help":
        return """
        xcf directives:
        - xcf: Activate XCF mode
        - grant permission: to use xcode automation
        - list projects in [folder]: list projects in folder
        - select project [#]
        - run: Execute the current XCF project
        - build: Build the current XCF project
        - help: Show this help information
        """
    case "grant permission":
        // May not be needed anymore... leave for now.
        let script = OsaScriptBuildFirstOpenXCodeDocument()
        return executeWithOsascript(script: script)
    case "run":
        guard let currentProject else { return "Error: No project selected"}
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: true)
    case "build":
        guard let currentProject else { return "Error: No project selected"}
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: false)
    case let cmd where cmd.starts(with: selectProject):
        return selectProjOrWS(withDirective: directive, selectProject: selectProject)
    case let cmd where cmd.starts(with: listProjectsIn):
        return listProjectsOrWorkspacesIn(directive, listProjectsIn, proj: true)
    default:
        // No recognized directive
        return "Unrecognized XCF directive: \(directive)\nUse 'help' to see available commands."
    }
}


