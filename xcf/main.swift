//
//  main.swift
//  xcf
//
//  Created by Todd Bruss on 5/3/25.
//

import Foundation
import MCP

// Check command-line arguments for "server" flag
if CommandLine.arguments.count > 1 && CommandLine.arguments[1] == "server" {
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
    
    // Keep the main thread running
    RunLoop.main.run()
} else {
    // Call the modal display function from a separate file
    ModalDisplay.showServerRequiredAlert()
}
