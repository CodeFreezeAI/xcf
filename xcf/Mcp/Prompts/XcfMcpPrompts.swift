import Foundation
import MCP

// MARK: - MCP Prompts

class XcfMcpPrompts {

    static func getAllPrompts() -> [Prompt] {
        return [
            createBuildPrompt(),
            createRunPrompt(),
            createAnalyzeCodePrompt(),
            createXcfActionPrompt()
        ]
    }

    // MARK: - Prompt Creation Functions

    private static func createBuildPrompt() -> Prompt {
        Prompt(
            name: McpConfig.buildPromptName,
            description: McpConfig.buildPromptDesc,
            arguments: [
                Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
            ]
        )
    }

    private static func createRunPrompt() -> Prompt {
        Prompt(
            name: McpConfig.runPromptName,
            description: McpConfig.runPromptDesc,
            arguments: [
                Prompt.Argument(name: McpConfig.projectPathArgName, description: McpConfig.projectPathArgDesc, required: true)
            ]
        )
    }

    private static func createAnalyzeCodePrompt() -> Prompt {
        Prompt(
            name: McpConfig.analyzeCodePromptName,
            description: McpConfig.analyzeCodePromptDesc,
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
                Prompt.Argument(name: McpConfig.includeSnippetArgName, description: McpConfig.includeSnippetArgDesc, required: false)
            ]
        )
    }

    private static func createXcfActionPrompt() -> Prompt {
        Prompt(
            name: "executeXcfAction",
            description: "Execute an xcf action or command",
            arguments: [
                Prompt.Argument(name: "action", description: "The xcf action to execute", required: true)
            ]
        )
    }
}
