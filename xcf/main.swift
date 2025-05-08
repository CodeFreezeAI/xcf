//
//  main.swift
//  xcf
//
//  Created by Todd Bruss on 5/3/25.
//

import Foundation
import MCP

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
