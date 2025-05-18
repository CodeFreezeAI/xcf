//
//  XcfMcpCollections.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

// Collections
extension XcfMcpServer {
    static let allTools = [
        xcfTool, listToolsTool, quickHelpTool, helpTool, snippetTool, analyzerTool, readDirTool,
        writeFileTool, readFileTool, cdDirTool,
        editFileTool, deleteFileTool,
        addDirTool, rmDirTool, moveFileTool, moveDirTool,
        openDocTool, closeDocTool, createDocTool, readDocTool, saveDocTool, editDocTool,
        useXcfTool,
        toolsReferenceTool
    ]

    static let allResources = [
        xcodeProjResource, 
        fileContentsResource, 
        buildResultsResource,
        codeSnippetResource,
        directoryContentsResource,
        codeAnalysisResource,
        xcodeDocumentResource,
        fileSystemResource
    ]

    static let allPrompts = [
        buildPrompt, runPrompt, analyzeCodePrompt,
        snippetPrompt, writeFilePrompt, readFilePrompt, cdDirPrompt,
        editFilePrompt, deleteFilePrompt, addDirPrompt, rmDirPrompt, readDirPrompt,
        openDocPrompt, createDocPrompt, readDocPrompt, saveDocPrompt, editDocPrompt, closeDocPrompt,
        moveFilePrompt, moveDirPrompt, xcfActionPrompt
    ]

}

// Generate Tool List
extension XcfMcpServer {
    
    static func getToolsList() -> String {
        var result = McpConfig.availableTools
        
        for tool in allTools {
            result += String(format: McpConfig.toolListFormat, tool.name, tool.description)
        }
        
        return result
    }
    
    static func getResourcesList() -> String {
        var result = McpConfig.availableResources
        
        for resource in allResources {
            result += String(format: McpConfig.resourceListFormat,
                             resource.name,
                             resource.uri,
                             resource.description ?? "")
        }
        
        return result
    }
    
    static func getPromptsList() -> String {
        var result = McpConfig.availablePrompts
        
        for prompt in allPrompts {
            result += String(format: McpConfig.promptListFormat,
                             prompt.name,
                             prompt.description ?? "")
        }
        
        return result
    }
}
// MARK: - Tool Call Handling
extension XcfMcpServer {
    
    /// Handles a tool call request
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    /// - Throws: Invalid parameter errors
    static func handleToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        switch params.name {
        case McpConfig.listToolsName:
            return CallTool.Result(content: [.text(getToolsList())])
            
        case McpConfig.xcfToolName:
            return try await handleXcfToolCall(params)
            
        case McpConfig.snippetToolName:
            return try handleSnippetToolCall(params)
            
        case McpConfig.analyzerToolName:
            return try handleAnalyzerToolCall(params)
            
        case McpConfig.quickHelpToolName:
            return handleQuickHelpToolCall(params)
            
        case McpConfig.helpToolName:
            return handleHelpToolCall(params)
            
        case McpConfig.useXcfToolName:
            return CallTool.Result(content: [.text(SuccessMessages.xcfActive)])
            
        case McpConfig.writeFileToolName:
            return try handleWriteFileToolCall(params)
            
        case McpConfig.readFileToolName:
            return try handleReadFileToolCall(params)
            
        case McpConfig.cdDirToolName:
            return try handleCdDirToolCall(params)
            
        case McpConfig.editFileToolName:
            return try handleEditFileToolCall(params)
            
        case McpConfig.deleteFileToolName:
            return try handleDeleteFileToolCall(params)
            
        case McpConfig.addDirToolName:
            return try handleAddDirToolCall(params)
            
        case McpConfig.rmDirToolName:
            return try handleRmDirToolCall(params)
            
        case McpConfig.openDocToolName:
            return try handleOpenDocToolCall(params)
            
        case McpConfig.createDocToolName:
            return try handleCreateDocToolCall(params)
            
        case McpConfig.readDocToolName:
            return try handleReadDocToolCall(params)
            
        case McpConfig.saveDocToolName:
            return try handleSaveDocToolCall(params)
            
        case McpConfig.editDocToolName:
            return try handleEditDocToolCall(params)
            
        case McpConfig.readDirToolName:
            return try handleReadDirToolCall(params)
            
        case McpConfig.moveFileToolName:
            return try handleMoveFileToolCall(params)
            
        case McpConfig.moveDirToolName:
            return try handleMoveDirToolCall(params)
            
        case McpConfig.closeDocToolName:
            return try handleCloseDocToolCall(params)
            
        case "tools":
            return handleToolsReferenceToolCall(params)
            
        case "xcf_help":
            return handleQuickHelpToolCall(params)
            
        default:
            throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
        }
    }
}
