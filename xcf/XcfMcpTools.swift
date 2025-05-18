//
//  XcfMcpTools.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25
//

import Foundation
import MCP

extension XcfMcpServer {
    static let listToolsTool = Tool(
        name: McpConfig.listToolsName,
        description: McpConfig.listToolsDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for quick help (xcf actions only)
    static let quickHelpTool = Tool(
        name: "xcf_help",
        description: "Help for xcf actions only",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for regular help
    static let helpTool = Tool(
        name: "help",
        description: "Regular help with common examples",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for tools reference
    static let toolsReferenceTool = Tool(
        name: "tools",
        description: "Show detailed reference for all tools including AI function calls",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )

    /// Tool for executing xcf actions
    static let xcfTool = Tool(
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
    
    /// Tool for activating XCF mode
    static let useXcfTool = Tool(
        name: McpConfig.useXcfToolName,
        description: McpConfig.useXcfToolDesc,
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for extracting code snippets from files
    static let snippetTool = Tool(
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
    
    /// Tool for analyzing Swift code
    static let analyzerTool = Tool(
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
    
    /// Tool for writing files
    static let writeFileTool = Tool(
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

    /// Tool for reading files
    static let readFileTool = Tool(
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

    /// Tool for changing directory
    static let cdDirTool = Tool(
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

    /// Tool for editing files
    static let editFileTool = Tool(
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

    /// Tool for deleting files
    static let deleteFileTool = Tool(
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

    /// Tool for adding directories
    static let addDirTool = Tool(
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

    /// Tool for removing directories
    static let rmDirTool = Tool(
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

    /// Tool for opening documents in Xcode
    static let openDocTool = Tool(
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

    /// Tool for creating documents in Xcode
    static let createDocTool = Tool(
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

    /// Tool for reading documents from Xcode
    static let readDocTool = Tool(
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

    /// Tool for saving documents in Xcode
    static let saveDocTool = Tool(
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

    /// Tool for editing documents in Xcode
    static let editDocTool = Tool(
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
    
    /// Tool for reading directories
    static let readDirTool = Tool(
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
    
    /// Tool for moving files
    static let moveFileTool = Tool(
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
    
    /// Tool for moving directories
    static let moveDirTool = Tool(
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
    
    /// Tool for closing documents in Xcode
    static let closeDocTool = Tool(
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
    
    // MARK: - Xcf Action Tools
    
    /// Tool for showing help
    static let showHelpTool = Tool(
        name: "show_help",
        description: "Display help information about available commands",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for granting permission
    static let grantPermissionTool = Tool(
        name: "grant_permission",
        description: "Grant Xcode automation permissions",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for running the current project
    static let runProjectTool = Tool(
        name: "run_project",
        description: "Run the current Xcode project",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for building the current project
    static let buildProjectTool = Tool(
        name: "build_project",
        description: "Build the current Xcode project",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for showing the current project
    static let showCurrentProjectTool = Tool(
        name: "show_current_project",
        description: "Show information about the currently selected project",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for showing environment variables
    static let showEnvTool = Tool(
        name: "show_env",
        description: "Display all environment variables",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for showing current folder
    static let showFolderTool = Tool(
        name: "show_folder",
        description: "Display the current working folder",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for listing projects
    static let listProjectsTool = Tool(
        name: "list_projects",
        description: "List all open Xcode projects",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType)
        ])
    )
    
    /// Tool for selecting a project
    static let selectProjectTool = Tool(
        name: "select_project",
        description: "Select an Xcode project by number",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                "projectNumber": .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string("The number of the project to select")
                ])
            ]),
            McpConfig.requiredKey: .array([.string("projectNumber")])
        ])
    )
    
    /// Tool for analyzing Swift code
    static let analyzeSwiftCodeTool = Tool(
        name: "analyze_swift_code",
        description: "Analyze Swift code for potential issues",
        inputSchema: .object([
            McpConfig.typeKey: .string(McpConfig.objectType),
            McpConfig.propertiesKey: .object([
                "filePath": .object([
                    McpConfig.typeKey: .string(McpConfig.stringType),
                    McpConfig.descriptionKey: .string("Path to the Swift file to analyze")
                ]),
                "startLine": .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string("Starting line number (1-indexed)")
                ]),
                "endLine": .object([
                    McpConfig.typeKey: .string(McpConfig.integerType),
                    McpConfig.descriptionKey: .string("Ending line number (1-indexed)")
                ]),
                "checkGroups": .object([
                    McpConfig.typeKey: .string("array"),
                    McpConfig.descriptionKey: .string("Check groups to perform (all, syntax, style, safety, performance, bestPractices)")
                ])
            ]),
            McpConfig.requiredKey: .array([.string("filePath")])
        ])
    )
    
}
