//
//  XcfMcpPrompts.swift
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
    
    /// Prompt for extracting code snippets
    static let snippetPrompt = Prompt(
        name: "extractCodeSnippet",
        description: "Extract a code snippet from a file",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "startLine", description: "Starting line number", required: false),
            Prompt.Argument(name: "endLine", description: "Ending line number", required: false),
            Prompt.Argument(name: "entireFile", description: "Whether to extract the entire file", required: false)
        ]
    )
    
    /// Prompt for writing a file
    static let writeFilePrompt = Prompt(
        name: "writeFile",
        description: "Write content to a file",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "content", description: "Content to write to the file", required: true)
        ]
    )
    
    /// Prompt for reading a file
    static let readFilePrompt = Prompt(
        name: "readFile",
        description: "Read content from a file",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
        ]
    )
    
    /// Prompt for changing directory
    static let cdDirPrompt = Prompt(
        name: "changeDirectory",
        description: "Change current directory",
        arguments: [
            Prompt.Argument(name: "directoryPath", description: "Path to the directory", required: true)
        ]
    )
    
    /// Prompt for editing a file
    static let editFilePrompt = Prompt(
        name: "editFile",
        description: "Edit content in a file",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "startLine", description: "Starting line number", required: true),
            Prompt.Argument(name: "endLine", description: "Ending line number", required: true),
            Prompt.Argument(name: "replacement", description: "Replacement text", required: true)
        ]
    )
    
    /// Prompt for deleting a file
    static let deleteFilePrompt = Prompt(
        name: "deleteFile",
        description: "Delete a file",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
        ]
    )
    
    /// Prompt for creating a directory
    static let addDirPrompt = Prompt(
        name: "createDirectory",
        description: "Create a new directory",
        arguments: [
            Prompt.Argument(name: "directoryPath", description: "Path to the directory", required: true)
        ]
    )
    
    /// Prompt for removing a directory
    static let rmDirPrompt = Prompt(
        name: "removeDirectory",
        description: "Remove a directory",
        arguments: [
            Prompt.Argument(name: "directoryPath", description: "Path to the directory", required: true)
        ]
    )
    
    /// Prompt for reading a directory
    static let readDirPrompt = Prompt(
        name: "readDirectory",
        description: "List contents of a directory",
        arguments: [
            Prompt.Argument(name: "directoryPath", description: "Path to the directory", required: true),
            Prompt.Argument(name: "fileExtension", description: "Filter by file extension", required: false)
        ]
    )
    
    /// Prompt for opening a document in Xcode
    static let openDocPrompt = Prompt(
        name: "openDocument",
        description: "Open a document in Xcode",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
        ]
    )
    
    /// Prompt for creating a document in Xcode
    static let createDocPrompt = Prompt(
        name: "createDocument",
        description: "Create a new document in Xcode",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "content", description: "Initial content", required: false)
        ]
    )
    
    /// Prompt for reading a document from Xcode
    static let readDocPrompt = Prompt(
        name: "readDocument",
        description: "Read document content from Xcode",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
        ]
    )
    
    /// Prompt for saving a document in Xcode
    static let saveDocPrompt = Prompt(
        name: "saveDocument",
        description: "Save document in Xcode",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true)
        ]
    )
    
    /// Prompt for editing a document in Xcode
    static let editDocPrompt = Prompt(
        name: "editDocument",
        description: "Edit document content in Xcode",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "startLine", description: "Starting line number", required: true),
            Prompt.Argument(name: "endLine", description: "Ending line number", required: true),
            Prompt.Argument(name: "replacement", description: "Replacement text", required: true)
        ]
    )
    
    /// Prompt for closing a document in Xcode
    static let closeDocPrompt = Prompt(
        name: "closeDocument",
        description: "Close a document in Xcode",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "saving", description: "Whether to save before closing", required: true)
        ]
    )
    
    /// Prompt for moving a file
    static let moveFilePrompt = Prompt(
        name: "moveFile",
        description: "Move a file from one location to another",
        arguments: [
            Prompt.Argument(name: "sourcePath", description: "Path of the file to move", required: true),
            Prompt.Argument(name: "destinationPath", description: "Path where the file should be moved to", required: true)
        ]
    )
    
    /// Prompt for moving a directory
    static let moveDirPrompt = Prompt(
        name: "moveDirectory",
        description: "Move a directory from one location to another",
        arguments: [
            Prompt.Argument(name: "sourcePath", description: "Path of the directory to move", required: true),
            Prompt.Argument(name: "destinationPath", description: "Path where the directory should be moved to", required: true)
        ]
    )
    
    /// Prompt for executing an xcf action
    static let xcfActionPrompt = Prompt(
        name: "executeXcfAction",
        description: "Execute an xcf action or command",
        arguments: [
            Prompt.Argument(name: "action", description: "The xcf action to execute", required: true)
        ]
    )
    
    /// Prompt for creating a diff between documents
    static let createDiffPrompt = Prompt(
        name: "createDiff",
        description: "Create a diff between documents or document sections",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "destString", description: "Destination string to compare against", required: true),
            Prompt.Argument(name: McpConfig.startLineArgName, description: "Optional starting line for partial document diff", required: false),
            Prompt.Argument(name: McpConfig.endLineArgName, description: "Optional ending line for partial document diff", required: false),
            Prompt.Argument(name: McpConfig.entireFileArgName, description: "Whether to use the entire file for diffing", required: false)
        ]
    )
    
    /// Prompt for applying a diff to a document
    static let applyDiffPrompt = Prompt(
        name: "applyDiff",
        description: "Apply diff operations to a document",
        arguments: [
            Prompt.Argument(name: McpConfig.filePathArgName, description: McpConfig.filePathArgDesc, required: true),
            Prompt.Argument(name: "operations", description: "Diff operations to apply", required: true)
        ]
    )
    
    // MARK: - Standalone Action Tool Prompts
    
    /// Prompt for showing help
    static let showHelpPrompt = Prompt(
        name: McpConfig.showHelpPromptName,
        description: McpConfig.showHelpToolDesc,
        arguments: []
    )
    
    /// Prompt for granting permission
    static let grantPermissionPrompt = Prompt(
        name: McpConfig.grantPermissionPromptName,
        description: McpConfig.grantPermissionToolDesc,
        arguments: []
    )
    
    /// Prompt for running a project (standalone)
    static let runProjectPrompt = Prompt(
        name: McpConfig.runProjectPromptName,
        description: McpConfig.runProjectToolDesc,
        arguments: []
    )
    
    /// Prompt for building a project (standalone)
    static let buildProjectPrompt = Prompt(
        name: McpConfig.buildProjectPromptName,
        description: McpConfig.buildProjectToolDesc,
        arguments: []
    )
    
    /// Prompt for showing current project
    static let showCurrentProjectPrompt = Prompt(
        name: McpConfig.showCurrentProjectPromptName,
        description: McpConfig.showCurrentProjectToolDesc,
        arguments: []
    )
    
    /// Prompt for showing environment variables
    static let showEnvPrompt = Prompt(
        name: McpConfig.showEnvPromptName,
        description: McpConfig.showEnvToolDesc,
        arguments: []
    )
    
    /// Prompt for showing current folder
    static let showFolderPrompt = Prompt(
        name: McpConfig.showFolderPromptName,
        description: McpConfig.showFolderToolDesc,
        arguments: []
    )
    
    /// Prompt for listing projects
    static let listProjectsPrompt = Prompt(
        name: McpConfig.listProjectsPromptName,
        description: McpConfig.listProjectsToolDesc,
        arguments: []
    )
    
    /// Prompt for selecting a project
    static let selectProjectPrompt = Prompt(
        name: McpConfig.selectProjectPromptName,
        description: McpConfig.selectProjectToolDesc,
        arguments: [
            Prompt.Argument(name: McpConfig.projectNumberParamName, description: McpConfig.projectNumberParamDesc, required: true)
        ]
    )
    
    /// Prompt for analyzing Swift code
    static let analyzeSwiftCodePrompt = Prompt(
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