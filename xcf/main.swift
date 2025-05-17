//
//  main.swift
//  xcf
//
//  Created by Todd Bruss on 5/3/25.
//

import Cocoa
import MCP

// Process command line arguments
func handleArguments() {
    // Check command-line arguments for "server" flag
    if CommandLine.arguments.count > 1 && CommandLine.arguments[1] == "server"  {
        // Print welcome message
        print(McpConfig.welcomeMessage)
        
        // Main async task
        Task.detached {
            do {
                // Configure and start the MCP server
                let server = try await McpServer.configureMcpServer()
                
                // Wait until the server completes
                await server.waitUntilCompleted()
            } catch {
                print(String(format: McpConfig.errorStartingServer, "\(error)"))
            }
        }
        
        // Initialize the application
        NSApplication.shared.setActivationPolicy(.prohibited)
        RunLoop.current.run()

    } else {
        // Call the modal display function from a separate file
        //ModalDisplay.showServerRequiredAlert()
        // Initialize the application
        NSApplication.shared.setActivationPolicy(.accessory)
        ModalDisplay.showServerRequiredAlert()
        NSApplication.shared.setActivationPolicy(.prohibited)
        exit(0)
    }
}

enum ModalDisplay {
    static func showServerRequiredAlert() {
        let alert = NSAlert()
        alert.messageText = "Use 'server' argument in your mcp.json"
        alert.informativeText = "/Applications/xcf.app/Contents/MacOS/xcf server"
        alert.alertStyle = .warning
        let quitButton = alert.addButton(withTitle: "Press to Quit this XCF Xcode MCP Server")
        quitButton.hasDestructiveAction = false
        quitButton.keyEquivalent = "\r" // Return key
        alert.runModal()
    }
}

// Set up signal handling for clean shutdown
signal(SIGINT) { _ in
    print("\nShutting down...")
    exit(0)
}

signal(SIGTERM) { _ in
    print("\nShutting down...")
    exit(0)
}

handleArguments()
