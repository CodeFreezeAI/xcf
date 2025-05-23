import Foundation
import MCP

// MARK: - Action-Specific Tool Handlers

class XcfMcpActionHandlers {
    
    /// Handles a call to the show help tool
    static func handleShowHelpToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.getHelpText())])
    }
    
    /// Handles a call to the grant permission tool
    static func handleGrantPermissionToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.grantPermission())])
    }
    
    /// Handles a call to the run project tool
    static func handleRunProjectToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.runProject())])
    }
    
    /// Handles a call to the build project tool
    static func handleBuildProjectToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.buildProject())])
    }
    
    /// Handles a call to the show current project tool
    static func handleShowCurrentProjectToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.showCurrentProject())])
    }
    
    /// Handles a call to the show environment variables tool
    static func handleShowEnvToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.showEnvironmentVariables())])
    }
    
    /// Handles a call to the show current folder tool
    static func handleShowFolderToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.showCurrentFolder())])
    }
    
    /// Handles a call to the list projects tool
    static func handleListProjectsToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return CallTool.Result(content: [.text(await XcfActionHandler.listProjects())])
    }
    
    /// Handles a call to the select project tool
    static func handleSelectProjectToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        if let projectNumber = params.arguments?[McpConfig.projectNumberParamName]?.intValue {
            let action = "open \(projectNumber)"
            return CallTool.Result(content: [.text(await XcfActionHandler.selectProject(action: action))])
        } else {
            return CallTool.Result(content: [.text(ErrorMessages.invalidProjectSelection)])
        }
    }
    
    /// Handles a call to the analyze Swift code tool
    static func handleAnalyzeSwiftCodeToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        guard let filePath = params.arguments?[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        var analyzeCommand = "analyze \(filePath)"
        
        // Add optional parameters if provided
        if let startLine = params.arguments?[McpConfig.startLineParamName]?.intValue,
           let endLine = params.arguments?[McpConfig.endLineParamName]?.intValue {
            analyzeCommand += " \(startLine) \(endLine)"
        }
        
        // Add check groups if provided
        if let checkGroups = params.arguments?[McpConfig.checkGroupsParamName]?.arrayValue,
           !checkGroups.isEmpty {
            for group in checkGroups {
                if let groupName = group.stringValue {
                    analyzeCommand += " \(groupName)"
                }
            }
        }
        
        return CallTool.Result(content: [.text(await XcfActionHandler.handleAnalyzeAction(action: analyzeCommand))])
    }
} 