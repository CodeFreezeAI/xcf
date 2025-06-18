import Foundation
import MCP

// MARK: - Help & Documentation Tool Handlers

class XcfMcpHelpHandlers {
    
    /// Handles a call to the quick help tool (xcf actions only)
    static func handleQuickHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(HelpText.basic)])
    }
    
    /// Handles a call to the regular help tool
    static func handleHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(HelpText.detailed)])
    }
    
    /// Handles a call to the tools reference tool
    static func handleToolsReferenceToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(HelpText.toolsReference)])
    }
} 