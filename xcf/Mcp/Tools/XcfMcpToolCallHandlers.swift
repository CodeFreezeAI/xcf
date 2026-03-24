import Foundation
import MCP

// MARK: - MCP Tool Call Handlers

class XcfMcpToolCallHandlers {

    // MARK: - Main Tool Call Handler

    /// Handles a tool call request - all calls route through the xcf action handler
    static func handleToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        switch params.name {
        case McpConfig.xcfToolName:
            return try await handleXcfToolCall(params)
        default:
            throw MCPError.invalidParams(String(format: ErrorMessages.unknownTool, params.name))
        }
    }

    // MARK: - Core Tool Handler

    /// Handles a call to the xcf tool
    static func handleXcfToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        if let action = params.arguments?[McpConfig.actionParamName]?.stringValue {
            return CallTool.Result(content: [.text(await XcfMcpActionHandler.handleAction(action: action))])
        } else {
            return CallTool.Result(content: [.text(await XcfMcpActionHandler.handleAction(action: Actions.help))])
        }
    }
}
