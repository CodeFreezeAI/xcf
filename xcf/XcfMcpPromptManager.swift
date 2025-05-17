// XcfMcpPromptManager.swift
// xcf
//
// Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

/// Manages all MCP prompts for the xcf application
class XcfMcpPromptManager: PromptProvider {
    static let shared = XcfMcpPromptManager()
    
    private init() {}
    
    // MARK: - Prompt Definitions
    
    /// Prompt for building a project
    private let buildPrompt = Prompt(
        name: McpConfig.buildPromptName,
        description: McpConfig.buildPromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
        ]
    )
    
    /// Prompt for running a project
    private let runPrompt = Prompt(
        name: McpConfig.runPromptName,
        description: McpConfig.runPromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
        ]
    )
    
    /// Prompt for analyzing code
    private let analyzeCodePrompt = Prompt(
        name: McpConfig.analyzeCodePromptName,
        description: McpConfig.analyzeCodePromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: McpConfig.includeSnippetArgName, description: McpConfig.includeSnippetArgDesc, required: false)
        ]
    )
    
    // MARK: - PromptProvider Implementation
    
    /// All prompts provided by this manager
    var prompts: [Prompt] {
        [buildPrompt, runPrompt, analyzeCodePrompt]
    }
    
    /// Generate a list of all available prompts
    /// - Returns: A formatted string containing all prompt names and descriptions
    func getPromptsList() -> String {
        var result = McpConfig.availablePrompts
        
        for prompt in prompts {
            result += String(format: McpConfig.promptListFormat,
                             prompt.name,
                             prompt.description ?? "")
        }
        
        return result
    }
    
    /// Handle a prompt request with the given parameters
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The result of the prompt request
    /// - Throws: Any errors that occur during prompt retrieval
    func handlePromptRequest(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        switch params.name {
        case McpConfig.buildPromptName:
            return handleBuildPrompt(params)
            
        case McpConfig.runPromptName:
            return handleRunPrompt(params)
            
        case McpConfig.analyzeCodePromptName:
            return handleAnalyzeCodePrompt(params)
            
        default:
            throw MCPError.invalidParams("Unknown prompt: \(params.name)")
        }
    }
    
    /// Handles a request for the build project prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The build project prompt
    private func handleBuildPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? "path/to/project"
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: "Build the project at \(projectPath)"))
        ]
        
        return GetPrompt.Result(description: "Build project prompt", messages: messages)
    }
    
    /// Handles a request for the run project prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The run project prompt
    private func handleRunPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? "path/to/project"
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: "Run the project at \(projectPath)"))
        ]
        
        return GetPrompt.Result(description: "Run project prompt", messages: messages)
    }
    
    /// Handles a request for the analyze code prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The analyze code prompt
    private func handleAnalyzeCodePrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get file path from arguments or use placeholder
        let filePath = params.arguments?[McpConfig.filePathArgName]?.stringValue ?? "path/to/file"
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: "Analyze the code at \(filePath)"))
        ]
        
        return GetPrompt.Result(description: "Analyze code prompt", messages: messages)
    }
} 
