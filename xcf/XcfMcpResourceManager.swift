// XcfMcpResourceManager.swift
// xcf
//
// Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

/// Manages all MCP resources for the xcf application
class XcfMcpResourceManager: ResourceProvider {
    static let shared = XcfMcpResourceManager()
    
    private init() {}
    
    // MARK: - Resource Definitions
    
    /// Resource for accessing Xcode projects
    private let xcodeProjResource = Resource(
        name: McpConfig.xcodeProjResourceName,
        uri: McpConfig.xcodeProjResourceURI,
        description: McpConfig.xcodeProjResourceDesc
    )
    
    /// Resource for accessing file contents
    private let fileContentsResource = Resource(
        name: McpConfig.fileContentsResourceName,
        uri: McpConfig.fileContentsResourceURI,
        description: McpConfig.fileContentsResourceDesc
    )
    
    /// Resource for accessing build results
    private let buildResultsResource = Resource(
        name: McpConfig.buildResultsResourceName,
        uri: McpConfig.buildResultsResourceURI,
        description: McpConfig.buildResultsResourceDesc
    )
    
    // MARK: - ResourceProvider Implementation
    
    /// All resources provided by this manager
    var resources: [Resource] {
        [xcodeProjResource, fileContentsResource, buildResultsResource]
    }
    
    /// Generate a list of all available resources
    /// - Returns: A formatted string containing all resource names, URIs, and descriptions
    func getResourcesList() -> String {
        var result = McpConfig.availableResources
        
        for resource in resources {
            result += String(format: McpConfig.resourceListFormat,
                             resource.name,
                             resource.uri,
                             resource.description ?? "")
        }
        
        return result
    }
    
    /// Handle a resource request with the given parameters
    /// - Parameter params: The parameters for the resource request
    /// - Returns: The result of the resource request
    /// - Throws: Any errors that occur during resource retrieval
    func handleResourceRequest(_ params: ReadResource.Parameters) async throws -> ReadResource.Result {
        // Implementation would be moved from XcfMcpServer
        throw MCPError.invalidParams("Resource handling not implemented")
    }
} 
