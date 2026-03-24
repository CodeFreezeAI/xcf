import Foundation
import MCP

// MARK: - MCP Tools

class XcfMcpTools {

    static func getAllTools() -> [Tool] {
        return [
            XcfTool()
        ]
    }

    // MARK: - Single Consolidated Tool

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
}
