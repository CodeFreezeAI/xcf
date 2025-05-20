//
//  XcfMcpCollections.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

//MARK: emoved til we have it right: editFileTool, deleteFileTool, editDocTool, moveFileTool, rmDirTool, moveDirTool, writeFileTool, addDirTool,


// Collections
extension XcfMcpServer {
    static let allTools = [
        xcfTool, listToolsTool, quickHelpTool, helpTool, snippetTool, analyzerTool, readDirTool,
        readFileTool, cdDirTool,
        openDocTool, closeDocTool, createDocTool, readDocTool, saveDocTool,
        useXcfTool,
        toolsReferenceTool,
        // New action-specific tools
        showHelpTool, grantPermissionTool, runProjectTool, buildProjectTool,
        showCurrentProjectTool, showEnvTool, showFolderTool,
        listProjectsTool, selectProjectTool, analyzeSwiftCodeTool,
        
        //MARK: NOT implemented yet
        //createDiffTool, applyDiffTool
    ]

    //MARK: removed resources til we have it right fileContentsResource,        directoryContentsResource,         fileSystemResource,

    static let allResources = [
        xcodeProjResource, 
        buildResultsResource,
        codeSnippetResource,
        codeAnalysisResource,
        xcodeDocumentResource,
        // Standalone action tool resources
        helpResource,
        permissionResource,
        projectManagementResource,
        environmentResource,
        directoryResource
    ]
    
    
    //MARK: removed prompts editFilePrompt, deleteFilePrompt, addDirPrompt, rmDirPrompt, readDirPrompt, moveFilePrompt, moveDirPrompt, editDocPrompt,  writeFilePrompt,

    static let allPrompts = [
        buildPrompt, runPrompt, analyzeCodePrompt,
        snippetPrompt, readFilePrompt, cdDirPrompt,
        
        openDocPrompt, createDocPrompt, readDocPrompt, saveDocPrompt, closeDocPrompt,
        xcfActionPrompt,
        // Standalone action tool prompts
        showHelpPrompt, grantPermissionPrompt, runProjectPrompt, buildProjectPrompt,
        showCurrentProjectPrompt, showEnvPrompt, showFolderPrompt,
        listProjectsPrompt, selectProjectPrompt, analyzeSwiftCodePrompt,
        
        //MARK: NOT implemented yet
        //createDiffPrompt, applyDiffPrompt,
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
        
        // Action-specific tool handlers
        case McpConfig.showHelpToolName:
            return await CallTool.Result(content: [.text(XcfActionHandler.getHelpText())])
            
        case McpConfig.grantPermissionToolName:
            return await CallTool.Result(content: [.text(XcfActionHandler.grantPermission())])
            
        case McpConfig.runProjectToolName:
            return CallTool.Result(content: [.text(await XcfActionHandler.runProject())])
            
        case McpConfig.buildProjectToolName:
            return CallTool.Result(content: [.text(await XcfActionHandler.buildProject())])
            
        case McpConfig.showCurrentProjectToolName:
            return await CallTool.Result(content: [.text(XcfActionHandler.showCurrentProject())])
            
        case McpConfig.showEnvToolName:
            return await CallTool.Result(content: [.text(XcfActionHandler.showEnvironmentVariables())])
            
        case McpConfig.showFolderToolName:
            return await CallTool.Result(content: [.text(XcfActionHandler.showCurrentFolder())])
            
        case McpConfig.listProjectsToolName:
            return await CallTool.Result(content: [.text(XcfActionHandler.listProjects())])
            
        case McpConfig.selectProjectToolName:
            if let projectNumber = params.arguments?[McpConfig.projectNumberParamName]?.intValue {
                let action = "open \(projectNumber)"
                return CallTool.Result(content: [.text(await XcfActionHandler.selectProject(action: action))])
            } else {
                return CallTool.Result(content: [.text(ErrorMessages.invalidProjectSelection)])
            }
            
        case McpConfig.analyzeSwiftCodeToolName:
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
            
            return await CallTool.Result(content: [.text(XcfActionHandler.handleAnalyzeAction(action: analyzeCommand))])
            
        default:
            throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
        }
    }
}

