import Foundation
import MCP

// MARK: - MCP Definitions Coordinator

class XcfMcpDefinitions {
    
    // MARK: - Coordinators
    
    static func getAllTools() -> [Tool] {
        return XcfMcpTools.getAllTools()
    }
    
    static func getAllResources() -> [Resource] {
        return XcfMcpResources.getAllResources()
    }
    
    static func getAllPrompts() -> [Prompt] {
        return XcfMcpPrompts.getAllPrompts()
    }
} 