// XcfMcpToolManager.swift
// xcf
//
// Created by Todd Bruss on 5/17/25.
//

import Foundation
import MCP

/// Manages all MCP tools for the xcf application
class XcfMcpToolManager: ToolMcpProvider {
    static let shared = XcfMcpToolManager()
    
    // Feature-specific operation handlers
    private let fileOperations: XcfFileOperations
    private let documentOperations: XcfDocumentOperations
    
    private init(fileOperations: XcfFileOperations = .shared,
                documentOperations: XcfDocumentOperations = .shared) {
        self.fileOperations = fileOperations
        self.documentOperations = documentOperations
    }
    
    // MARK: - Tool Definitions
    
    /// Tool for listing available tools
    private let listToolsTool = Tool(
        name: McpConfig.listToolsName,
        description: McpConfig.listToolsDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for executing xcf actions
    private let xcfTool = Tool(
        name: McpConfig.xcfToolName,
        description: McpConfig.xcfToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                McpConfig.actionParamName: .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string(McpConfig.actionParamDesc)
                ])
            ]),
            McpConfig.requiredKey: .array([.string(McpConfig.actionParamName)])
        ])
    )
    
    /// Tool for quick help (xcf actions only)
    private let quickHelpTool = Tool(
        name: "xcf_help",
        description: "Help for xcf actions only",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for regular help
    private let helpTool = Tool(
        name: "help",
        description: "Regular help with common examples",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for tools reference
    private let toolsReferenceTool = Tool(
        name: "tools",
        description: "Show detailed reference for all tools including AI function calls",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for activating XCF mode
    private let useXcfTool = Tool(
        name: McpConfig.useXcfToolName,
        description: McpConfig.useXcfToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    // MARK: - ToolProvider Implementation
    
    /// Get all tools provided by this manager
    var tools: [Tool] {
        [
            listToolsTool, xcfTool, quickHelpTool, helpTool, useXcfTool, toolsReferenceTool
        ] + fileTools + documentTools
    }
    
    /// All file-related tools
    private var fileTools: [Tool] {
        [
            snippetTool, analyzerTool, readDirTool, writeFileTool, readFileTool, cdDirTool,
            editFileTool, deleteFileTool, addDirTool, rmDirTool, moveFileTool, moveDirTool
        ]
    }
    
    /// All document-related tools
    private var documentTools: [Tool] {
        [
            openDocTool, createDocTool, readDocTool, saveDocTool, editDocTool
        ]
    }
    
    // MARK: - Tool Call Handling
    
    /// Handle a tool call with the given parameters
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    /// - Throws: Any errors that occur during tool execution
    func handleToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        switch params.name {
        // Core tools
        case McpConfig.listToolsName:
            return CallTool.Result(content: [.text(getToolsList())])
            
        case McpConfig.xcfToolName:
            return try await handleXcfToolCall(params)
            
        case McpConfig.quickHelpToolName:
            return handleQuickHelpToolCall(params)
            
        case McpConfig.helpToolName:
            return handleHelpToolCall(params)
            
        case McpConfig.useXcfToolName:
            return CallTool.Result(content: [.text(SuccessMessages.xcfActive)])
            
        case "tools":
            return handleToolsReferenceToolCall(params)
            
        // File operations tools
        case McpConfig.snippetToolName:
            return try fileOperations.handleSnippetToolCall(params)
            
        case McpConfig.analyzerToolName:
            return try fileOperations.handleAnalyzerToolCall(params)
            
        case McpConfig.writeFileToolName:
            return try fileOperations.handleWriteFileToolCall(params)
            
        case McpConfig.readFileToolName:
            return try fileOperations.handleReadFileToolCall(params)
            
        case McpConfig.cdDirToolName:
            return try fileOperations.handleCdDirToolCall(params)
            
        case McpConfig.editFileToolName:
            return try fileOperations.handleEditFileToolCall(params)
            
        case McpConfig.deleteFileToolName:
            return try fileOperations.handleDeleteFileToolCall(params)
            
        case McpConfig.addDirToolName:
            return try fileOperations.handleAddDirToolCall(params)
            
        case McpConfig.rmDirToolName:
            return try fileOperations.handleRmDirToolCall(params)
            
        case McpConfig.readDirToolName:
            return try fileOperations.handleReadDirToolCall(params)
            
        case McpConfig.moveFileToolName:
            return try fileOperations.handleMoveFileToolCall(params)
            
        case McpConfig.moveDirToolName:
            return try fileOperations.handleMoveDirToolCall(params)
            
        // Document operations tools
        case McpConfig.openDocToolName:
            return try documentOperations.handleOpenDocToolCall(params)
            
        case McpConfig.createDocToolName:
            return try documentOperations.handleCreateDocToolCall(params)
            
        case McpConfig.readDocToolName:
            return try documentOperations.handleReadDocToolCall(params)
            
        case McpConfig.saveDocToolName:
            return try documentOperations.handleSaveDocToolCall(params)
            
        case McpConfig.editDocToolName:
            return try documentOperations.handleEditDocToolCall(params)
            
        default:
            throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
        }
    }
    
    // MARK: - Core Tool Handlers
    
    /// Handle an xcf tool call
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    /// - Throws: Any errors that occur during tool execution
    private func handleXcfToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        // Implementation would be moved from the previous function
        return CallTool.Result(content: [.text("XCF command execution")])
    }
    
    /// Handle a quick help tool call
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    private func handleQuickHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        // Implementation would be moved from the previous function
        return CallTool.Result(content: [.text("Quick help information")])
    }
    
    /// Handle a help tool call
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    private func handleHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        // Implementation would be moved from the previous function
        return CallTool.Result(content: [.text("Help information")])
    }
    
    /// Handle a tools reference tool call
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    private func handleToolsReferenceToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        // Implementation would be moved from the previous function
        return CallTool.Result(content: [.text("Tools reference information")])
    }
    
    // MARK: - Tools List Generation
    
    /// Generate a list of all available tools
    /// - Returns: A formatted string containing all tool names and descriptions
    func getToolsList() -> String {
        var result = McpConfig.availableTools
        
        for tool in tools {
            result += String(format: McpConfig.toolListFormat, tool.name, tool.description)
        }
        
        return result
    }
}

// MARK: - File Tools Extension
extension XcfMcpToolManager {
    /// Tool for extracting code snippets from files
    private var snippetTool: Tool {
        Tool(
            name: McpConfig.snippetToolName,
            description: McpConfig.snippetToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.startLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                    ]),
                    McpConfig.endLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                    ]),
                    McpConfig.entireFileParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.booleanType),
                        McpConfig.descriptionKey: .string(McpConfig.entireFileParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for analyzing Swift code
    private var analyzerTool: Tool {
        Tool(
            name: McpConfig.analyzerToolName,
            description: McpConfig.analyzerToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.startLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                    ]),
                    McpConfig.endLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                    ]),
                    McpConfig.entireFileParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.booleanType),
                        McpConfig.descriptionKey: .string(McpConfig.entireFileParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for reading directories
    private var readDirTool: Tool {
        Tool(
            name: McpConfig.readDirToolName,
            description: McpConfig.readDirToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.directoryPathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                    ]),
                    McpConfig.fileExtensionParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.fileExtensionParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
            ])
        )
    }
    
    /// Tool for writing files
    private var writeFileTool: Tool {
        Tool(
            name: McpConfig.writeFileToolName,
            description: McpConfig.writeFileToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.contentParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.contentParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName), .string(McpConfig.contentParamName)])
            ])
        )
    }
    
    /// Tool for reading files
    private var readFileTool: Tool {
        Tool(
            name: McpConfig.readFileToolName,
            description: McpConfig.readFileToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for changing directory
    private var cdDirTool: Tool {
        Tool(
            name: McpConfig.cdDirToolName,
            description: McpConfig.cdDirToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.directoryPathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
            ])
        )
    }
    
    /// Tool for editing files
    private var editFileTool: Tool {
        Tool(
            name: McpConfig.editFileToolName,
            description: McpConfig.editFileToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.startLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                    ]),
                    McpConfig.endLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                    ]),
                    McpConfig.replacementParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.replacementParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([
                    .string(McpConfig.filePathParamName),
                    .string(McpConfig.startLineParamName),
                    .string(McpConfig.endLineParamName),
                    .string(McpConfig.replacementParamName)
                ])
            ])
        )
    }
    
    /// Tool for deleting files
    private var deleteFileTool: Tool {
        Tool(
            name: McpConfig.deleteFileToolName,
            description: McpConfig.deleteFileToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for adding directories
    private var addDirTool: Tool {
        Tool(
            name: McpConfig.addDirToolName,
            description: McpConfig.addDirToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.directoryPathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
            ])
        )
    }
    
    /// Tool for removing directories
    private var rmDirTool: Tool {
        Tool(
            name: McpConfig.rmDirToolName,
            description: McpConfig.rmDirToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.directoryPathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.directoryPathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.directoryPathParamName)])
            ])
        )
    }
    
    /// Tool for moving files
    private var moveFileTool: Tool {
        Tool(
            name: McpConfig.moveFileToolName,
            description: McpConfig.moveFileToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    "sourcePath": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Path of the file to move")
                    ]),
                    "destinationPath": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Path where the file should be moved to")
                    ])
                ]),
                McpConfig.requiredKey: .array([.string("sourcePath"), .string("destinationPath")])
            ])
        )
    }
    
    /// Tool for moving directories
    private var moveDirTool: Tool {
        Tool(
            name: McpConfig.moveDirToolName,
            description: "Move a directory from one location to another",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    "sourcePath": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Path of the directory to move")
                    ]),
                    "destinationPath": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Path where the directory should be moved to")
                    ])
                ]),
                McpConfig.requiredKey: .array([.string("sourcePath"), .string("destinationPath")])
            ])
        )
    }
}

// MARK: - Document Tools Extension
extension XcfMcpToolManager {
    /// Tool for opening documents in Xcode
    private var openDocTool: Tool {
        Tool(
            name: McpConfig.openDocToolName,
            description: McpConfig.openDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for creating documents in Xcode
    private var createDocTool: Tool {
        Tool(
            name: McpConfig.createDocToolName,
            description: McpConfig.createDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.contentParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.contentParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for reading documents from Xcode
    private var readDocTool: Tool {
        Tool(
            name: McpConfig.readDocToolName,
            description: McpConfig.readDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for saving documents in Xcode
    private var saveDocTool: Tool {
        Tool(
            name: McpConfig.saveDocToolName,
            description: McpConfig.saveDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    /// Tool for editing documents in Xcode
    private var editDocTool: Tool {
        Tool(
            name: McpConfig.editDocToolName,
            description: McpConfig.editDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.startLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.startLineParamDesc)
                    ]),
                    McpConfig.endLineParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.endLineParamDesc)
                    ]),
                    McpConfig.replacementParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.replacementParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([
                    .string(McpConfig.filePathParamName),
                    .string(McpConfig.startLineParamName),
                    .string(McpConfig.endLineParamName),
                    .string(McpConfig.replacementParamName)
                ])
            ])
        )
    }
} 
