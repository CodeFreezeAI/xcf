//
//  main.swift
//  xcf
//
//  Created by Todd Bruss on 5/3/25.
//

import Foundation
import MCP
import AppKit

// Check command-line arguments for "server" flag
if CommandLine.arguments.count > 1 && CommandLine.arguments[1] == "server" {
    // Print welcome message
    print(McpConfig.welcomeMessage)
    
    // Main async task
    Task {
        do {
            // Configure and start the MCP server
            let server = try await McpServer.configureMcpServer()
            
            // Wait until the server completes
            await server.waitUntilCompleted()
        } catch {
            print(String(format: McpConfig.errorStartingServer, "\(error)"))
        }
    }
    
    // Keep the main thread running
    RunLoop.main.run()
} else {
    // Show alert that this is a server application
    let alert = NSAlert()

    alert.messageText = "Use 'server' argument in your mcp.json"
    alert.informativeText = "/Applications/xcf.app/Contents/MacOS/xcf server"
    alert.alertStyle = .warning
    
    // Add "I Understand, Quit" button with blue styling
    let quitButton = alert.addButton(withTitle: "Press to Quit this XCF Xcode MCP Server")
    quitButton.hasDestructiveAction = false
    quitButton.keyEquivalent = "\r" // Return key
    
    // Run the alert modal
    alert.runModal()
    
    // Exit application
    exit(0)
}
