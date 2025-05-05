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
            return CallTool.Result(content: [.text(handleXcfDirective(directive: directive))])
        } else {
            print("No directive found, using help")
            // If no directive specified, return the help information
            return CallTool.Result(content: [.text(handleXcfDirective(directive: "help"))])
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

func handleXcfDirective(directive: String) -> String {
    
    // Convert directive to lowercase for case-insensitive matching
    let lowercasedDirective = directive.lowercased()
   
    switch lowercasedDirective {
    case "use xcf", "xcf":
        return "All xcf systems go!"
    case "help", "list", "xcf help":
        return """
        xcf directives:
        - xcf: Activate XCF mode
        - grant permission: to use xcode automation
        - list projects in [folder] like ~/Documents
        - select project [#]
        - list workspaces in [folder] like ~/Documents
        - select workspace [#]
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
        
    // Projects
    case let cmd where cmd.starts(with: Directives.listProjectsIn):
        return listProjectsOrWorkspacesIn(directive, Directives.listProjectsIn, proj: true)
    case let cmd where cmd.starts(with: Directives.selectProject):
        return selectProjectOrWorkspace(withDirective: directive, projectOrWorkspace: Directives.selectProject, proj: true)
        
    // Workspaces
    case let cmd where cmd.starts(with: Directives.listWorkspacesIn):
        return listProjectsOrWorkspacesIn(directive, Directives.listWorkspacesIn, proj: false)
    case let cmd where cmd.starts(with: Directives.selectWorkspace):
        return selectProjectOrWorkspace(withDirective: directive, projectOrWorkspace: Directives.selectWorkspace, proj: false)
        
    default:
        // No recognized directive
        return "Houston we have a problem: \(directive) is not recognized."
    }
}


