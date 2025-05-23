import Foundation
import MCP

// MARK: - MCP Prompts

class XcfMcpPrompts {
    
    static func getAllPrompts() -> [Prompt] {
        return [
            createBuildPrompt(),
            createRunPrompt(),
            createAnalyzeCodePrompt(),
            createSnippetPrompt(),
            createReadFilePrompt(),
            createCdDirPrompt(),
            createOpenDocPrompt(),
            createCreateDocPrompt(),
            createReadDocPrompt(),
            createSaveDocPrompt(),
            createCloseDocPrompt(),
            createXcfActionPrompt(),
            createShowHelpPrompt(),
            createGrantPermissionPrompt(),
            createRunProjectPrompt(),
            createBuildProjectPrompt(),
            createShowCurrentProjectPrompt(),
            createShowEnvPrompt(),
            createShowFolderPrompt(),
            createListProjectsPrompt(),
            createSelectProjectPrompt(),
            createAnalyzeSwiftCodePrompt()
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
    
    private static func createSnippetPrompt() -> Prompt {
        Prompt(
            name: "extractCodeSnippet",
            description: "Extract a code snippet from a file",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
                Prompt.Argument(name: "startLine", description: "Starting line number", required: false),
                Prompt.Argument(name: "endLine", description: "Ending line number", required: false),
                Prompt.Argument(name: "entireFile", description: "Whether to extract the entire file", required: false)
            ]
        )
    }
    
    private static func createReadFilePrompt() -> Prompt {
        Prompt(
            name: "readFile",
            description: "Read content from a file",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
            ]
        )
    }
    
    private static func createCdDirPrompt() -> Prompt {
        Prompt(
            name: "changeDirectory",
            description: "Change current directory",
            arguments: [
                Prompt.Argument(name: "directoryPath", description: "Path to the directory", required: true)
            ]
        )
    }
    
    private static func createOpenDocPrompt() -> Prompt {
        Prompt(
            name: "openDocument",
            description: "Open a document in Xcode",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
            ]
        )
    }
    
    private static func createCreateDocPrompt() -> Prompt {
        Prompt(
            name: "createDocument",
            description: "Create a new document in Xcode",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
                Prompt.Argument(name: "content", description: "Initial content", required: false)
            ]
        )
    }
    
    private static func createReadDocPrompt() -> Prompt {
        Prompt(
            name: "readDocument",
            description: "Read document content from Xcode",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
            ]
        )
    }
    
    private static func createSaveDocPrompt() -> Prompt {
        Prompt(
            name: "saveDocument",
            description: "Save document in Xcode",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
            ]
        )
    }
    
    private static func createCloseDocPrompt() -> Prompt {
        Prompt(
            name: "closeDocument",
            description: "Close a document in Xcode",
            arguments: [
                Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
                Prompt.Argument(name: "saving", description: "Whether to save before closing", required: true)
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
    
    private static func createShowHelpPrompt() -> Prompt {
        Prompt(
            name: McpConfig.showHelpPromptName,
            description: McpConfig.showHelpToolDesc,
            arguments: []
        )
    }
    
    private static func createGrantPermissionPrompt() -> Prompt {
        Prompt(
            name: McpConfig.grantPermissionPromptName,
            description: McpConfig.grantPermissionToolDesc,
            arguments: []
        )
    }
    
    private static func createRunProjectPrompt() -> Prompt {
        Prompt(
            name: McpConfig.runProjectPromptName,
            description: McpConfig.runProjectToolDesc,
            arguments: []
        )
    }
    
    private static func createBuildProjectPrompt() -> Prompt {
        Prompt(
            name: McpConfig.buildProjectPromptName,
            description: McpConfig.buildProjectToolDesc,
            arguments: []
        )
    }
    
    private static func createShowCurrentProjectPrompt() -> Prompt {
        Prompt(
            name: McpConfig.showCurrentProjectPromptName,
            description: McpConfig.showCurrentProjectToolDesc,
            arguments: []
        )
    }
    
    private static func createShowEnvPrompt() -> Prompt {
        Prompt(
            name: McpConfig.showEnvPromptName,
            description: McpConfig.showEnvToolDesc,
            arguments: []
        )
    }
    
    private static func createShowFolderPrompt() -> Prompt {
        Prompt(
            name: McpConfig.showFolderPromptName,
            description: McpConfig.showFolderToolDesc,
            arguments: []
        )
    }
    
    private static func createListProjectsPrompt() -> Prompt {
        Prompt(
            name: McpConfig.listProjectsPromptName,
            description: McpConfig.listProjectsToolDesc,
            arguments: []
        )
    }
    
    private static func createSelectProjectPrompt() -> Prompt {
        Prompt(
            name: McpConfig.selectProjectPromptName,
            description: McpConfig.selectProjectToolDesc,
            arguments: [
                Prompt.Argument(name: McpConfig.projectNumberParamName, description: McpConfig.projectNumberParamDesc, required: true)
            ]
        )
    }
    
    private static func createAnalyzeSwiftCodePrompt() -> Prompt {
        Prompt(
            name: McpConfig.analyzeSwiftCodePromptName,
            description: McpConfig.analyzeSwiftCodeToolDesc,
            arguments: [
                Prompt.Argument(name: McpConfig.filePathParamName, description: McpConfig.filePathParamDesc, required: true),
                Prompt.Argument(name: McpConfig.startLineParamName, description: McpConfig.startLineParamDesc, required: false),
                Prompt.Argument(name: McpConfig.endLineParamName, description: McpConfig.endLineParamDesc, required: false),
                Prompt.Argument(name: McpConfig.checkGroupsParamName, description: McpConfig.checkGroupsParamDesc, required: false)
            ]
        )
    }
} 