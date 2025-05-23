import Foundation
import MCP

// MARK: - MCP Resource Handlers

class XcfMcpResourceHandlers {
    
    /// Handles a resource request
    static func handleResourceRequest(_ params: ReadResource.Parameters) async throws -> ReadResource.Result {
        switch params.uri {
        case McpConfig.xcodeProjResourceURI:
            return try await handleXcodeProjectsResource()
            
        case McpConfig.fileContentsResourceURI:
            return try handleFileContentsResource(uri: params.uri)
            
        case McpConfig.buildResultsResourceURI:
            return try await handleBuildResultsResource()
            
        default:
            throw MCPError.invalidParams(String(format: McpConfig.unknownResourceUriError, params.uri))
        }
    }
    
    /// Handles a request for the Xcode projects resource
    static func handleXcodeProjectsResource() async throws -> ReadResource.Result {
        let projects = await XcfActionHandler.getSortedXcodeProjects()
        let content = Resource.Content.text(
            projects.joined(separator: McpConfig.newLineSeparator),
            uri: McpConfig.xcodeProjResourceURI
        )
        return ReadResource.Result(contents: [content])
    }
    
    /// Handles a request for the build results resource
    static func handleBuildResultsResource() async throws -> ReadResource.Result {
        guard let currentProject = await XcfActionHandler.getCurrentProject() else {
            throw MCPError.invalidParams(ErrorMessages.noProjectSelected)
        }
        
        let buildResults = XcfMcpServer.XcfScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        let content = Resource.Content.text(
            buildResults,
            uri: McpConfig.buildResultsResourceURI
        )
        return ReadResource.Result(contents: [content])
    }
    
    /// Handles a request for the file contents resource
    static func handleFileContentsResource(uri: String) throws -> ReadResource.Result {
        guard let filePath = XcfMcpHandlers.extractFilePathFromUri(uri) else {
            throw MCPError.invalidParams(McpConfig.missingFilePathParamError)
        }
        
        do {
            let (fileContents, warning) = try XcfFileManager.readFile(at: filePath)
            let content = Resource.Content.text(
                warning.isEmpty ? fileContents : warning + "\n\n" + fileContents,
                uri: "\(McpConfig.fileContentsResourceURI)/\(filePath)",
                mimeType: McpConfig.plainTextMimeType
            )
            return ReadResource.Result(contents: [content])
        } catch let error as NSError {
            throw MCPError.invalidParams(error.localizedDescription)
        }
    }
} 