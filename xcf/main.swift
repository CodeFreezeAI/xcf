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
let swiftVersionTool = Tool(
    name: "swift_version",
    description: "Returns the current Swift version",
    inputSchema: .object([
        "type": .string("object")
    ])
)

let systemInfoTool = Tool(
    name: "system_info",
    description: "Returns information about the system",
    inputSchema: .object([
        "type": .string("object")
    ])
)

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
let allTools = [swiftVersionTool, systemInfoTool, listToolsTool, xcfTool]

// Handle tool listing
await server.withMethodHandler(ListTools.self) { params in
    ListTools.Result(tools: allTools)
}

// Handle tool calls
await server.withMethodHandler(CallTool.self) { params in
  
    switch params.name {
    case "swift_version":
        return CallTool.Result(content: [.text(getSwiftVersion())])
    case "system_info":
        return CallTool.Result(content: [.text(getSystemInfo())])
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

// Tool implementations
func getSwiftVersion() -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["swift", "--version"]
    
    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    
    do {
        try process.run()
        process.waitUntilExit()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? "No version"
    } catch {
        return "Error running swift-version: \(error)"
    }
}

func getSystemInfo() -> String {
    var info = [String]()
    
    // Get OS version
    let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
    info.append("OS Version: \(osVersion)")
    
    // Get hostname
    if let hostname = Host.current().localizedName {
        info.append("Hostname: \(hostname)")
    }
    
    // Get architecture
    #if arch(x86_64)
    info.append("Architecture: x86_64")
    #elseif arch(arm64)
    info.append("Architecture: arm64")
    #else
    info.append("Architecture: unknown")
    #endif
    
    return info.joined(separator: "\n")
}

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
    case "use xcf":
        return("welcome to xcf in pure swift\nxcodefreeze mcp local server\ncopyright 2025 codefreeze.ai\n")
    case "help", "xcf help":
        return """
        
        XCF Directives Help:
        - use xcf: Activate XCF mode
        - grant permission: to use xcode automation
        - list projects in [folder]: list projects in folder
        - select project [#]
        - run: Execute the current XCF project
        - build: Build the current XCF project
        - help: Show this help information
        """
    case "grant permission":
        let script = OsaScriptBuildFirstOpenXCodeDocument()
        return executeWithOsascript(script: script)
    case "run":
        guard let currentProject else { return "Error: No project selected"}
        print("Running current project \(currentProject)...")
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: true)
        
    case "build":
        guard let currentProject else { return "Error: No project selected"}
        print("Building current project \(currentProject)...")
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: false)
        
    case let cmd where cmd.starts(with: selectProject):
        let startIndex = directive.index(directive.startIndex, offsetBy: selectProject.count)
        let index = String(directive[startIndex...]).trimmingCharacters(in: .whitespaces)
        
        let projects = getListOfProjectsRecursively(inFolderPath: defaultFolderPath)
        
        guard !projects.isEmpty else { return "No projects found" }
        
        var num = Int(index) ?? 0
        if num < 1 {
            num = 1
        }
        
        if num > projects.count {
            return "Error: Project number \(num) is out of range. Only \(projects.count) projects available."
        }
        
        currentProject = projects[num - 1]
        return currentProject ?? ""
        
    case let cmd where cmd.starts(with: listProjectsIn):
        let startIndex = directive.index(directive.startIndex, offsetBy: listProjectsIn.count)
        let folderPath = String(directive[startIndex...]).trimmingCharacters(in: .whitespaces)
        
        // Handle tilde expansion for home directory
        defaultFolderPath = folderPath
        if folderPath.starts(with: "~") {
            if let homeDir = ProcessInfo.processInfo.environment["HOME"] {
                defaultFolderPath = folderPath.replacingOccurrences(of: "~", with: homeDir)
            }
        }
        
        let projects = getListOfProjectsRecursively(inFolderPath: defaultFolderPath)
        var result = "List of Projects in \(folderPath)!!"
        
        if projects.isEmpty {
            result += "\nNo projects found."
        } else {
            for (index, project) in projects.enumerated() {
                result += "\n\(index + 1). \(project)"
            }
        }
        
        return result
        
    default:
        // No recognized directive
        print("Unrecognized XCF directive: \(directive)\nUse 'help' to see available commands.")
        return "Unrecognized XCF directive: \(directive)\nUse 'help' to see available commands."
    }
}
