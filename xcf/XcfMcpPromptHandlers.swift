import Foundation
import MCP

// MARK: - MCP Prompt Handlers

class XcfMcpPromptHandlers {
    
    /// Handles a prompt request
    static func handlePromptRequest(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        switch params.name {
        case McpConfig.buildPromptName:
            return handleBuildPrompt(params)
            
        case McpConfig.runPromptName:
            return handleRunPrompt(params)
            
        case McpConfig.analyzeCodePromptName:
            return try handleAnalyzeCodePrompt(params)
            
        default:
            throw MCPError.invalidParams(String(format: McpConfig.unknownPromptNameError, params.name))
        }
    }
    
    /// Handles a request for the build project prompt
    static func handleBuildPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? McpConfig.projectPathPlaceholder
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: String(format: McpConfig.buildProjectTemplate, projectPath)))
        ]
        
        return GetPrompt.Result(description: McpConfig.buildProjectResultDesc, messages: messages)
    }
    
    /// Handles a request for the run project prompt
    static func handleRunPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? McpConfig.projectPathPlaceholder
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: String(format: McpConfig.runProjectTemplate, projectPath)))
        ]
        
        return GetPrompt.Result(description: McpConfig.runProjectResultDesc, messages: messages)
    }
    
    /// Handles a request for the analyze code prompt
    static func handleAnalyzeCodePrompt(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        // Get file path from arguments or use placeholder
        let filePath = params.arguments?[McpConfig.filePathArgName]?.stringValue ?? McpConfig.filePathPlaceholder
        let includeSnippet = params.arguments?[McpConfig.includeSnippetArgName]?.boolValue ?? false
        
        // Create the base message
        let baseMessage = Prompt.Message(
            role: .user,
            content: .text(text: String(format: McpConfig.analyzeCodeTemplate, filePath))
        )
        
        var messages: [Prompt.Message] = [baseMessage]
        
        // Add code snippet if requested
        if includeSnippet {
            if let snippetMessage = try? XcfMcpCodeSnippetHandlers.createCodeSnippetMessage(filePath: filePath) {
                messages.append(snippetMessage)
            }
            // If snippet creation fails, we still return the base message
        }
        
        return GetPrompt.Result(description: McpConfig.analyzeCodeResultDesc, messages: messages)
    }
} 