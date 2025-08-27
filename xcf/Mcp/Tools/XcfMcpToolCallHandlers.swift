import Foundation
import MCP
import MultiLineDiff

//typealias StringIndex = String.Index

// MARK: - MCP Tool Call Handlers

class XcfMcpToolCallHandlers {
    
    // MARK: - Main Tool Call Handler
    
    /// Handles a tool call request
    static func handleToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        switch params.name {
        case McpConfig.listToolsName:
            return CallTool.Result(content: [.text(XcfMcpHandlers.getToolsList())])
            
        case McpConfig.xcfToolName:
            return try await handleXcfToolCall(params)
            
        case McpConfig.snippetToolName:
            return try XcfMcpCodeAnalysisHandlers.handleSnippetToolCall(params)
            
        case McpConfig.analyzerToolName:
            return try XcfMcpCodeAnalysisHandlers.handleAnalyzerToolCall(params)
            
        case McpConfig.quickHelpToolName:
            return XcfMcpHelpHandlers.handleQuickHelpToolCall(params)
            
        case McpConfig.helpToolName:
            return XcfMcpHelpHandlers.handleHelpToolCall(params)
            
        case McpConfig.useXcfToolName:
            return CallTool.Result(content: [.text(SuccessMessages.xcfActive)])
            
        case McpConfig.readFileToolName:
            return try XcfMcpFileSystemHandlers.handleReadFileToolCall(params)
            
        case McpConfig.cdDirToolName:
            return try XcfMcpFileSystemHandlers.handleCdDirToolCall(params)
            
        case McpConfig.openDocToolName:
            return try XcfMcpXcodeDocumentHandlers.handleOpenDocToolCall(params)
            
        case McpConfig.createDocToolName:
            return try XcfMcpXcodeDocumentHandlers.handleCreateDocToolCall(params)
            
        case McpConfig.readDocToolName:
            return try XcfMcpXcodeDocumentHandlers.handleReadDocToolCall(params)
            
        case McpConfig.saveDocToolName:
            return try XcfMcpXcodeDocumentHandlers.handleSaveDocToolCall(params)
            
        case McpConfig.readDirToolName:
            return try XcfMcpFileSystemHandlers.handleReadDirToolCall(params)
            
        case McpConfig.closeDocToolName:
            return try XcfMcpXcodeDocumentHandlers.handleCloseDocToolCall(params)
            
        case McpConfig.tools:
            return XcfMcpHelpHandlers.handleToolsReferenceToolCall(params)
            
        case McpConfig.xcfHelp:
            return XcfMcpHelpHandlers.handleQuickHelpToolCall(params)

        case McpConfig.createDiff:
            return try XcfMcpDiffHandlers.handleCreateDiffToolCall(params)
            
        case McpConfig.applyDiff:
            return try XcfMcpDiffHandlers.handleApplyDiffToolCall(params)
            
        case McpConfig.getAsciiDiff:
            return try XcfMcpDiffHandlers.handleGetAsciiDiffToolCall(params)
            
        case McpConfig.createDiffFromDocToolName:
            return try XcfMcpDiffHandlers.handleCreateDiffFromDocToolCall(params)
            
        case McpConfig.applyUndoDiffToDocToolName:
            return try XcfMcpDiffHandlers.handleApplyUndoDiffToDocToolCall(params)
            
        case McpConfig.applyDiffToDocToolName:
            return try XcfMcpDiffHandlers.handleApplyDiffToDocToolCall(params)
        
        // Action-specific tool handlers - delegate to specialized handler
        case McpConfig.showHelpToolName:
            return await XcfMcpActionHandlers.handleShowHelpToolCall(params)
            
        case McpConfig.grantPermissionToolName:
            return await XcfMcpActionHandlers.handleGrantPermissionToolCall(params)
            
        case McpConfig.runProjectToolName:
            return await XcfMcpActionHandlers.handleRunProjectToolCall(params)
            
        case McpConfig.buildProjectToolName:
            return await XcfMcpActionHandlers.handleBuildProjectToolCall(params)
            
        case McpConfig.showCurrentProjectToolName:
            return await XcfMcpActionHandlers.handleShowCurrentProjectToolCall(params)
            
        case McpConfig.showEnvToolName:
            return await XcfMcpActionHandlers.handleShowEnvToolCall(params)
            
        case McpConfig.showFolderToolName:
            return await XcfMcpActionHandlers.handleShowFolderToolCall(params)
            
        case McpConfig.listProjectsToolName:
            return await XcfMcpActionHandlers.handleListProjectsToolCall(params)
            
        case McpConfig.selectProjectToolName:
            return await XcfMcpActionHandlers.handleSelectProjectToolCall(params)
            
        case McpConfig.analyzeSwiftCodeToolName:
            return await XcfMcpActionHandlers.handleAnalyzeSwiftCodeToolCall(params)
            
        default:
            throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
        }
    }
    
    // MARK: - Core Tool Handler
    
    /// Handles a call to the xcf tool
    static func handleXcfToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        if let action = params.arguments?[McpConfig.actionParamName]?.stringValue {
            return CallTool.Result(content: [.text(await XcfMcpActionHandler.handleAction(action: action))])
        } else {
            // If no action specified, return the help information
            return CallTool.Result(content: [.text(await XcfMcpActionHandler.handleAction(action: Actions.help))])
        }
    }
} 
