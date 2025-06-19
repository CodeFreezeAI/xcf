import Foundation
import MCP

// MARK: - Help Tool Handlers

class XcfMcpHelpHandlers {
    /// Handles a call to the help tool
    static func handleHelpToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return XcfMcpToolHelpers.textResult(HelpText.basic)
    }
    
    /// Handles a call to the tools tool
    static func handleToolsToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return XcfMcpToolHelpers.textResult(HelpText.detailed)
    }
    
    /// Handles a call to the xcf_help tool
    static func handleXcfHelpToolCall(_ params: CallTool.Parameters) async -> CallTool.Result {
        return XcfMcpToolHelpers.textResult(HelpText.toolsReference)
    }
} 