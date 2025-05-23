import Foundation
import MCP

// MARK: - Code Analysis Tool Handlers

class XcfMcpCodeAnalysisHandlers {
    
    /// Handles a call to the snippet tool
    static func handleSnippetToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        let entireFile = arguments[McpConfig.entireFileParamName]?.boolValue ?? false
        let startLine = arguments[McpConfig.startLineParamName]?.intValue
        let endLine = arguments[McpConfig.endLineParamName]?.intValue
        
        return XcfMcpCodeSnippetHandlers.handleCodeSnippet(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
    
    /// Handles a call to the analyzer tool
    static func handleAnalyzerToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathError)])
        }
        
        let entireFile = arguments[McpConfig.entireFileParamName]?.boolValue ?? false
        let startLine = arguments[McpConfig.startLineParamName]?.intValue
        let endLine = arguments[McpConfig.endLineParamName]?.intValue
        
        return XcfMcpCodeSnippetHandlers.handleAnalyzerCodeSnippet(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
} 