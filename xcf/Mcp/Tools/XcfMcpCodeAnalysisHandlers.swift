import Foundation
import MCP

// MARK: - Code Analysis Tool Handlers

class XcfMcpCodeAnalysisHandlers {
    
    /// Handles a call to the snippet tool
    static func handleSnippetToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        // Extract arguments
        let (arguments, errorResult) = XcfMcpToolHelpers.extractArguments(from: params, errorMessage: McpConfig.missingFilePathError)
        if let errorResult = errorResult { return errorResult }
        
        // Extract file path
        let (filePath, filePathError) = XcfMcpToolHelpers.extractFilePath(from: arguments!)
        if let filePathError = filePathError { return filePathError }
        
        // Extract code analysis parameters
        let (entireFile, startLine, endLine) = XcfMcpToolHelpers.extractCodeAnalysisParams(from: arguments!)
        
        return XcfMcpCodeSnippetHandlers.handleCodeSnippet(
            filePath: filePath!,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
    
    /// Handles a call to the analyzer tool
    static func handleAnalyzerToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        // Extract arguments
        let (arguments, errorResult) = XcfMcpToolHelpers.extractArguments(from: params, errorMessage: McpConfig.missingFilePathError)
        if let errorResult = errorResult { return errorResult }
        
        // Extract file path
        let (filePath, filePathError) = XcfMcpToolHelpers.extractFilePath(from: arguments!)
        if let filePathError = filePathError { return filePathError }
        
        // Extract code analysis parameters
        let (entireFile, startLine, endLine) = XcfMcpToolHelpers.extractCodeAnalysisParams(from: arguments!)
        
        return XcfMcpCodeSnippetHandlers.handleAnalyzerCodeSnippet(
            filePath: filePath!,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
} 