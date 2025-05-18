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
    
    /// Resource for accessing code snippets
    static let codeSnippetResource = Resource(
        name: "codeSnippet",
        uri: "\(AppConstants.appName)://resources/codeSnippet",
        description: "Extracted code snippets from files"
    )
    
    /// Resource for accessing directory contents
    static let directoryContentsResource = Resource(
        name: "directoryContents",
        uri: "\(AppConstants.appName)://resources/directoryContents",
        description: "Directory contents and structure"
    )
    
    /// Resource for accessing code analysis
    static let codeAnalysisResource = Resource(
        name: "codeAnalysis",
        uri: "\(AppConstants.appName)://resources/codeAnalysis",
        description: "Results of code analysis"
    )
    
    /// Resource for accessing Xcode document contents
    static let xcodeDocumentResource = Resource(
        name: "xcodeDocument",
        uri: "\(AppConstants.appName)://resources/xcodeDocument",
        description: "Content and status of Xcode documents"
    )
    
    /// Resource for accessing file system operations
    static let fileSystemResource = Resource(
        name: "fileSystem",
        uri: "\(AppConstants.appName)://resources/fileSystem",
        description: "Status and information about file system operations"
    )
    
    // MARK: - Standalone Action Tool Resources
    
    /// Resource for accessing help information
    static let helpResource = Resource(
        name: McpConfig.helpResourceName,
        uri: McpConfig.helpResourceURI,
        description: McpConfig.helpResourceDesc
    )
    
    /// Resource for accessing permission status
    static let permissionResource = Resource(
        name: McpConfig.permissionResourceName,
        uri: McpConfig.permissionResourceURI,
        description: McpConfig.permissionResourceDesc
    )
    
    /// Resource for accessing project management
    static let projectManagementResource = Resource(
        name: McpConfig.projectManagementResourceName,
        uri: McpConfig.projectManagementResourceURI,
        description: McpConfig.projectManagementResourceDesc
    )
    
    /// Resource for accessing environment information
    static let environmentResource = Resource(
        name: McpConfig.environmentResourceName,
        uri: McpConfig.environmentResourceURI,
        description: McpConfig.environmentResourceDesc
    )
    
    /// Resource for accessing directory information
    static let directoryResource = Resource(
        name: McpConfig.directoryResourceName,
        uri: McpConfig.directoryResourceURI,
        description: McpConfig.directoryResourceDesc
    )
}
