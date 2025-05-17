//
//  XcfMcpPrompt.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25.
//

import MCP

extension XcfMcpServer {
    // MARK: - Prompt Definitions
    
    /// Prompt for building a project
    static let buildPrompt = Prompt(
        name: McpConfig.buildPromptName,
        description: McpConfig.buildPromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
        ]
    )
    
    /// Prompt for running a project
    static let runPrompt = Prompt(
        name: McpConfig.runPromptName,
        description: McpConfig.runPromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
        ]
    )
    
    /// Prompt for analyzing code
    static let analyzeCodePrompt = Prompt(
        name: McpConfig.analyzeCodePromptName,
        description: McpConfig.analyzeCodePromptDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: McpConfig.includeSnippetArgName, description: McpConfig.includeSnippetArgDesc, required: false)
        ]
    )
}
