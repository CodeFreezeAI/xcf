//
//  XcfMcpResources.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//

import MCP

extension XcfMcpServer {
    // MARK: - Resource Definitions
    
    /// Resource for accessing Xcode projects
    static let xcodeProjResource = Resource(
        name: McpConfig.xcodeProjResourceName,
        uri: McpConfig.xcodeProjResourceURI,
        description: McpConfig.xcodeProjResourceDesc
    )
    
    /// Resource for accessing file contents
    static let fileContentsResource = Resource(
        name: McpConfig.fileContentsResourceName,
        uri: McpConfig.fileContentsResourceURI,
        description: McpConfig.fileContentsResourceDesc
    )
    
    /// Resource for accessing build results
    static let buildResultsResource = Resource(
        name: McpConfig.buildResultsResourceName,
        uri: McpConfig.buildResultsResourceURI,
        description: McpConfig.buildResultsResourceDesc
    )
}
