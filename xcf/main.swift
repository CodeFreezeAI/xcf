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

func getOpenProjectsList(projs: [String]) -> String {
    var result = ""
    
    for (index, proj) in projs.enumerated() {
        result += "\(index + 1). \(proj)\n"
    }
    
    return result
}

// Get sorted list of Xcode projects
func getSortedXcodeProjects(ext: String = ".xc") -> [String] {
    let xc = AppleScriptDescriptorToSet(script: getXcodeDocumentPaths(ext: ext))
    return Array(xc).sorted() // Convert Set to Array and sort alphabetically
}

@MainActor
func handleXcfDirective(directive: String) -> String {
    
    // Convert directive to lowercase for case-insensitive matching
    let lowercasedDirective = directive.lowercased()
   
    switch lowercasedDirective {
    case "use xcf", "xcf":
        return "All xcf systems go!"
    case "help", "xcf help":
        return """
        xcf directives:
        - xcf: Activate XCF mode
        - grant: permission to use xcode automation
        - list: [open xc projects and workspaces]
        - select #: [open xc project or workspace]
        - run: Execute the current XCF project
        - build: Build the current XCF project
        - help: Show this help information
        """
    case "grant":
        // May not be needed anymore... leave for now.
        let script = OsaScriptBuildFirstOpenXCodeDocument()
        return executeWithOsascript(script: script)
    case "run":
        guard let currentProject else { return "Error: No project selected"}
        let XcodeBuildScript = XcodeBuildScript()
        let buildCheckForErrors = XcodeBuildScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        
        if buildCheckForErrors.contains("success") {
            return XcodeBuildScript.buildCurrentWorkspace(projectPath: currentProject, run: true)
        } else {
            return buildCheckForErrors
        }
    case "build":
        guard let currentProject else { return "Error: No project selected"}
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: false)
        
    // Projects
    case let cmd where cmd.starts(with: Directives.list):
        let xcArray = getSortedXcodeProjects()

        if xcArray.isEmpty {
            return "Error: No open projects."
        }
        
        return getOpenProjectsList(projs: xcArray)
    case let cmd where cmd.starts(with: Directives.select):
        // Refactored: Handle 'select N' directive concisely
        func parseProjectNumber(from directive: String) -> Int? {
            let parts = directive.split(separator: " ")
            guard parts.count >= 2, let n = Int(parts[1]) else { return nil }
            return n
        }
        guard let projectNumber = parseProjectNumber(from: directive) else {
            return "Error: Invalid project selection format. Use 'select N' where N is the project number."
        }
        let xcArray = getSortedXcodeProjects()
        guard !xcArray.isEmpty else {
            return "Error: No open projects."
        }
        guard (1...xcArray.count).contains(projectNumber) else {
            return "Error: Project number \(projectNumber) is out of range. Available projects: 1-\(xcArray.count)"
        }
        currentProject = xcArray[projectNumber - 1]
        return "Selected project \(projectNumber): \(currentProject ?? "")"
    default:
        // No recognized directive
        return "Houston we have a problem: \(directive) is not recognized."
    }
}


