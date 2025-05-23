//
//  XcfMcpCollections.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

// MARK: - Legacy Collections (Deprecated)
// This file has been replaced by XcfMcpTools.swift, XcfMcpResources.swift, and XcfMcpPrompts.swift
// Keep this for backward compatibility during transition

extension XcfMcpServer {
    // Legacy collections - now delegate to the separate specialized classes
    static let allTools = XcfMcpTools.getAllTools()
    static let allResources = XcfMcpResources.getAllResources() 
    static let allPrompts = XcfMcpPrompts.getAllPrompts()
}

// Generate Tool List - now delegates to handlers
extension XcfMcpServer {
    static func getToolsList() -> String {
        return XcfMcpHandlers.getToolsList()
    }
    
    static func getResourcesList() -> String {
        return XcfMcpHandlers.getResourcesList()
    }
    
    static func getPromptsList() -> String {
        return XcfMcpHandlers.getPromptsList()
    }
}

