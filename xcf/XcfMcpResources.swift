import Foundation
import MCP

// MARK: - MCP Resources

class XcfMcpResources {
    
    static func getAllResources() -> [Resource] {
        return [
            createXcodeProjResource(),
            createBuildResultsResource(),
            createCodeSnippetResource(),
            createCodeAnalysisResource(),
            createXcodeDocumentResource(),
            createHelpResource(),
            createPermissionResource(),
            createProjectManagementResource(),
            createEnvironmentResource(),
            createDirectoryResource()
        ]
    }
    
    // MARK: - Resource Creation Functions
    
    private static func createXcodeProjResource() -> Resource {
        Resource(
            name: McpConfig.xcodeProjResourceName,
            uri: McpConfig.xcodeProjResourceURI,
            description: McpConfig.xcodeProjResourceDesc
        )
    }
    
    private static func createBuildResultsResource() -> Resource {
        Resource(
            name: McpConfig.buildResultsResourceName,
            uri: McpConfig.buildResultsResourceURI,
            description: McpConfig.buildResultsResourceDesc
        )
    }
    
    private static func createCodeSnippetResource() -> Resource {
        Resource(
            name: "codeSnippet",
            uri: "\(AppConstants.appName)://resources/codeSnippet",
            description: "Extracted code snippets from files"
        )
    }
    
    private static func createCodeAnalysisResource() -> Resource {
        Resource(
            name: "codeAnalysis",
            uri: "\(AppConstants.appName)://resources/codeAnalysis",
            description: "Results of code analysis"
        )
    }
    
    private static func createXcodeDocumentResource() -> Resource {
        Resource(
            name: "xcodeDocument",
            uri: "\(AppConstants.appName)://resources/xcodeDocument",
            description: "Content and status of Xcode documents"
        )
    }
    
    private static func createHelpResource() -> Resource {
        Resource(
            name: McpConfig.helpResourceName,
            uri: McpConfig.helpResourceURI,
            description: McpConfig.helpResourceDesc
        )
    }
    
    private static func createPermissionResource() -> Resource {
        Resource(
            name: McpConfig.permissionResourceName,
            uri: McpConfig.permissionResourceURI,
            description: McpConfig.permissionResourceDesc
        )
    }
    
    private static func createProjectManagementResource() -> Resource {
        Resource(
            name: McpConfig.projectManagementResourceName,
            uri: McpConfig.projectManagementResourceURI,
            description: McpConfig.projectManagementResourceDesc
        )
    }
    
    private static func createEnvironmentResource() -> Resource {
        Resource(
            name: McpConfig.environmentResourceName,
            uri: McpConfig.environmentResourceURI,
            description: McpConfig.environmentResourceDesc
        )
    }
    
    private static func createDirectoryResource() -> Resource {
        Resource(
            name: McpConfig.directoryResourceName,
            uri: McpConfig.directoryResourceURI,
            description: McpConfig.directoryResourceDesc
        )
    }
} 