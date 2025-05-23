import Foundation
import MCP

// MARK: - MCP Tools

class XcfMcpTools {
    
    static func getAllTools() -> [Tool] {
        return [
            createXcfTool(),
            createListTool(),
            createQuickHelpTool(),
            createHelpTool(),
            createSnippetTool(),
            createAnalyzerTool(),
            createReadDirTool(),
            createReadFileTool(),
            createCdDirTool(),
            createOpenDocTool(),
            createCloseDocTool(),
            createCreateDocTool(),
            createReadDocTool(),
            createSaveDocTool(),
            createUseXcfTool(),
            createToolsReferenceTool(),
            createShowHelpTool(),
            createGrantPermissionTool(),
            createRunProjectTool(),
            createBuildProjectTool(),
            createShowCurrentProjectTool(),
            createShowEnvTool(),
            createShowFolderTool(),
            createListProjectsTool(),
            createSelectProjectTool(),
            createAnalyzeSwiftCodeTool(),
            createCreateDiffTool(),
            createApplyDiffTool()
        ]
    }
    
    // MARK: - Tool Creation Functions
    
    private static func createXcfTool() -> Tool {
        Tool(
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
    }
    
    private static func createListTool() -> Tool {
        Tool(
            name: McpConfig.listToolsName,
            description: McpConfig.listToolsDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createQuickHelpTool() -> Tool {
        Tool(
            name: "xcf_help",
            description: "Help for xcf actions only",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createHelpTool() -> Tool {
        Tool(
            name: "help",
            description: "Regular help with common examples",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createSnippetTool() -> Tool {
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
    
    private static func createAnalyzerTool() -> Tool {
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
    
    private static func createReadDirTool() -> Tool {
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
    
    private static func createReadFileTool() -> Tool {
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
    
    private static func createCdDirTool() -> Tool {
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
    
    private static func createOpenDocTool() -> Tool {
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
    
    private static func createCloseDocTool() -> Tool {
        Tool(
            name: McpConfig.closeDocToolName,
            description: McpConfig.closeDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    "saving": .object([
                        McpConfig.typeKey: .string(McpConfig.booleanType),
                        McpConfig.descriptionKey: .string("Whether to save the document before closing")
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName), .string("saving")])
            ])
        )
    }
    
    private static func createCreateDocTool() -> Tool {
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
    
    private static func createReadDocTool() -> Tool {
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
    
    private static func createSaveDocTool() -> Tool {
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
    
    private static func createUseXcfTool() -> Tool {
        Tool(
            name: McpConfig.useXcfToolName,
            description: McpConfig.useXcfToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createToolsReferenceTool() -> Tool {
        Tool(
            name: "tools",
            description: "Show detailed reference for all tools including AI function calls",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createShowHelpTool() -> Tool {
        Tool(
            name: McpConfig.showHelpToolName,
            description: McpConfig.showHelpToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createGrantPermissionTool() -> Tool {
        Tool(
            name: McpConfig.grantPermissionToolName,
            description: McpConfig.grantPermissionToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createRunProjectTool() -> Tool {
        Tool(
            name: McpConfig.runProjectToolName,
            description: McpConfig.runProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createBuildProjectTool() -> Tool {
        Tool(
            name: McpConfig.buildProjectToolName,
            description: McpConfig.buildProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createShowCurrentProjectTool() -> Tool {
        Tool(
            name: McpConfig.showCurrentProjectToolName,
            description: McpConfig.showCurrentProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createShowEnvTool() -> Tool {
        Tool(
            name: McpConfig.showEnvToolName,
            description: McpConfig.showEnvToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createShowFolderTool() -> Tool {
        Tool(
            name: McpConfig.showFolderToolName,
            description: McpConfig.showFolderToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createListProjectsTool() -> Tool {
        Tool(
            name: McpConfig.listProjectsToolName,
            description: McpConfig.listProjectsToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func createSelectProjectTool() -> Tool {
        Tool(
            name: McpConfig.selectProjectToolName,
            description: McpConfig.selectProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.projectNumberParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.integerType),
                        McpConfig.descriptionKey: .string(McpConfig.projectNumberParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.projectNumberParamName)])
            ])
        )
    }
    
    private static func createAnalyzeSwiftCodeTool() -> Tool {
        Tool(
            name: McpConfig.analyzeSwiftCodeToolName,
            description: McpConfig.analyzeSwiftCodeToolDesc,
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
                    McpConfig.checkGroupsParamName: .object([
                        McpConfig.typeKey: .string("array"),
                        McpConfig.descriptionKey: .string(McpConfig.checkGroupsParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName)])
            ])
        )
    }
    
    private static func createCreateDiffTool() -> Tool {
        Tool(
            name: "create_diff",
            description: "Create a diff between documents or document sections",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    "sourceString": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Source string to modify")
                    ]),
                    "destString": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Destination string to create")
                    ])
                ]),
                McpConfig.requiredKey: .array([.string("sourceString"), .string("destString")])
            ])
        )
    }
    
    private static func createApplyDiffTool() -> Tool {
        Tool(
            name: "apply_diff",
            description: "Apply diff operations to a document",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    "sourceString": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("Source string to modify")
                    ]),
                    "uuid": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("uuid of the diff to apply")
                    ])
                ]),
                McpConfig.requiredKey: .array([.string("sourceString"), .string("uuid")])
            ])
        )
    }
} 