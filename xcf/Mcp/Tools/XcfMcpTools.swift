import Foundation
import MCP

// MARK: - MCP Tools

class XcfMcpTools {
    
    static func getAllTools() -> [Tool] {
        return [
            XcfTool(),
            ListTool(),
            QuickHelpTool(),
            HelpTool(),
            SnippetTool(),
            AnalyzerTool(),
            ReadDirTool(),
            ReadFileTool(),
            CdDirTool(),
            OpenDocTool(),
            CloseDocTool(),
            CreateDocTool(),
            ReadDocTool(),
            SaveDocTool(),
            UseXcfTool(),
            ToolsReferenceTool(),
            ShowHelpTool(),
            GrantPermissionTool(),
            RunProjectTool(),
            BuildProjectTool(),
            ShowCurrentProjectTool(),
            ShowEnvTool(),
            ShowFolderTool(),
            ListProjectsTool(),
            SelectProjectTool(),
            AnalyzeSwiftCodeTool(),
            CreateDiffTool(),
            ApplyDiffTool(),
            GetAsciiDiffTool(),
            CreateDiffFromDocTool(),
            ApplyDiffToDocTool(),
            ApplyUndoDiffToDocTool()
        ]
    }
    
    // MARK: - Tool Creation Functions
    
    private static func XcfTool() -> Tool {
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
    
    private static func ListTool() -> Tool {
        Tool(
            name: McpConfig.listToolsName,
            description: McpConfig.listToolsDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func QuickHelpTool() -> Tool {
        Tool(
            name: "xcf_help",
            description: "Help for xcf actions only",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func HelpTool() -> Tool {
        Tool(
            name: "help",
            description: "Regular help with common examples",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func SnippetTool() -> Tool {
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
    
    private static func AnalyzerTool() -> Tool {
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
    
    private static func ReadDirTool() -> Tool {
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
    
    private static func ReadFileTool() -> Tool {
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
    
    private static func CdDirTool() -> Tool {
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
    
    private static func OpenDocTool() -> Tool {
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
    
    private static func CloseDocTool() -> Tool {
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
    
    private static func CreateDocTool() -> Tool {
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
    
    private static func ReadDocTool() -> Tool {
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
    
    private static func SaveDocTool() -> Tool {
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
    
    private static func UseXcfTool() -> Tool {
        Tool(
            name: McpConfig.useXcfToolName,
            description: McpConfig.useXcfToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func ToolsReferenceTool() -> Tool {
        Tool(
            name: "tools",
            description: "Show detailed reference for all tools including AI function calls",
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func ShowHelpTool() -> Tool {
        Tool(
            name: McpConfig.showHelpToolName,
            description: McpConfig.showHelpToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func GrantPermissionTool() -> Tool {
        Tool(
            name: McpConfig.grantPermissionToolName,
            description: McpConfig.grantPermissionToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func RunProjectTool() -> Tool {
        Tool(
            name: McpConfig.runProjectToolName,
            description: McpConfig.runProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func BuildProjectTool() -> Tool {
        Tool(
            name: McpConfig.buildProjectToolName,
            description: McpConfig.buildProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func ShowCurrentProjectTool() -> Tool {
        Tool(
            name: McpConfig.showCurrentProjectToolName,
            description: McpConfig.showCurrentProjectToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func ShowEnvTool() -> Tool {
        Tool(
            name: McpConfig.showEnvToolName,
            description: McpConfig.showEnvToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func ShowFolderTool() -> Tool {
        Tool(
            name: McpConfig.showFolderToolName,
            description: McpConfig.showFolderToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func ListProjectsTool() -> Tool {
        Tool(
            name: McpConfig.listProjectsToolName,
            description: McpConfig.listProjectsToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType)
            ])
        )
    }
    
    private static func SelectProjectTool() -> Tool {
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
    
    private static func AnalyzeSwiftCodeTool() -> Tool {
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
    
    private static func CreateDiffTool() -> Tool {
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
    
    private static func ApplyDiffTool() -> Tool {
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
                    "diffHash": .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string("SHA256 hash of the diff to apply")
                    ])
                ]),
                McpConfig.requiredKey: .array([.string("sourceString"), .string("diffHash")])
            ])
        )
    }
    
    private static func CreateDiffFromDocTool() -> Tool {
        Tool(
            name: McpConfig.createDiffFromDocToolName,
            description: McpConfig.createDiffFromDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.modifiedContentParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.modifiedContentParamNameDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName),.string(McpConfig.modifiedContentParamName)])
            ])
        )
    }
    
    private static func ApplyDiffToDocTool() -> Tool {
        Tool(
            name: McpConfig.applyDiffToDocToolName,
            description: McpConfig.applyDiffToDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.diffHashParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.diffHashParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName), .string(McpConfig.diffHashParamName)])
            ])
        )
    }
    
    private static func ApplyUndoDiffToDocTool() -> Tool {
        Tool(
            name: McpConfig.applyUndoDiffToDocToolName,
            description: McpConfig.applyUndoDiffToDocToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.filePathParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.filePathParamDesc)
                    ]),
                    McpConfig.diffHashParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.diffHashParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.filePathParamName), .string(McpConfig.diffHashParamName)])
            ])
        )
    }
    
    private static func GetAsciiDiffTool() -> Tool {
        Tool(
            name: McpConfig.getAsciiDiff,
            description: McpConfig.getAsciiDiffToolDesc,
            inputSchema: .object([
                McpConfig.typeKey: .string(McpConfig.objectType),
                McpConfig.propertiesKey: .object([
                    McpConfig.diffHashParamName: .object([
                        McpConfig.typeKey: .string(McpConfig.stringType),
                        McpConfig.descriptionKey: .string(McpConfig.diffHashParamDesc)
                    ])
                ]),
                McpConfig.requiredKey: .array([.string(McpConfig.diffHashParamName)])
            ])
        )
    }
}
