import Foundation
import MCP

// MARK: - Tool Handler Helper Functions

/// Common helper functions to reduce code duplication across tool handlers
class XcfMcpToolHelpers {
    
    // MARK: - Result Creation Helpers
    
    /// Creates a CallTool.Result with text content
    static func textResult(_ text: String) -> CallTool.Result {
        CallTool.Result(content: [.text(text)])
    }
    
    /// Creates a CallTool.Result with formatted text content
    static func formattedTextResult(_ format: String, _ arguments: CVarArg...) -> CallTool.Result {
        CallTool.Result(content: [.text(String(format: format, arguments))])
    }
    
    /// Creates a CallTool.Result with error message
    static func errorResult(_ errorFormat: String, _ errorDescription: String) -> CallTool.Result {
        CallTool.Result(content: [.text(String(format: errorFormat, errorDescription))])
    }
    
    // MARK: - Parameter Extraction Helpers
    
    /// Extracts arguments from CallTool.Parameters, returning nil if missing
    static func extractArguments(from params: CallTool.Parameters, errorMessage: String? = nil) -> (arguments: [String: ServerRequest.JSONValue]?, result: CallTool.Result?) {
        guard let arguments = params.arguments else {
            let message = errorMessage ?? "Missing arguments"
            return (nil, textResult(message))
        }
        return (arguments, nil)
    }
    
    /// Extracts a file path from arguments using standard fallback logic
    static func extractFilePath(from arguments: [String: ServerRequest.JSONValue], paramName: String = McpConfig.filePathParamName, errorMessage: String? = nil) -> (filePath: String?, result: CallTool.Result?) {
        // Try named parameter first
        if let namedPath = arguments[paramName]?.stringValue {
            return (namedPath, nil)
        }
        
        // Try first argument as fallback
        if let firstArg = arguments.first?.value.stringValue {
            return (firstArg, nil)
        }
        
        // Return error
        let message = errorMessage ?? McpConfig.missingFilePathError
        return (nil, textResult(message))
    }
    
    /// Extracts a string parameter from arguments with error handling
    static func extractStringParam(from arguments: [String: ServerRequest.JSONValue], paramName: String, errorMessage: String) -> (value: String?, result: CallTool.Result?) {
        guard let value = arguments[paramName]?.stringValue else {
            return (nil, textResult(errorMessage))
        }
        return (value, nil)
    }
    
    /// Extracts common code analysis parameters
    static func extractCodeAnalysisParams(from arguments: [String: ServerRequest.JSONValue]) -> (entireFile: Bool, startLine: Int?, endLine: Int?) {
        let entireFile = arguments[McpConfig.entireFileParamName]?.boolValue ?? false
        let startLine = arguments[McpConfig.startLineParamName]?.intValue
        let endLine = arguments[McpConfig.endLineParamName]?.intValue
        return (entireFile, startLine, endLine)
    }
    
    // MARK: - Directory Path Helpers
    
    /// Extracts and resolves a directory path with special handling for ".", "..", and current directory
    static func extractDirectoryPath(from arguments: [String: ServerRequest.JSONValue], currentFolder: String, paramName: String = McpConfig.directoryPathParamName) -> String {
        // Check named parameter
        if let namedPath = arguments[paramName]?.stringValue {
            return resolveDirectoryPath(namedPath, relativeTo: currentFolder)
        }
        
        // Check first argument
        if let firstArg = arguments.first?.value.stringValue {
            return resolveDirectoryPath(firstArg, relativeTo: currentFolder)
        }
        
        // Default to current folder
        return currentFolder
    }
    
    /// Resolves special directory paths like "." and ".."
    private static func resolveDirectoryPath(_ path: String, relativeTo currentFolder: String) -> String {
        switch path {
        case ".":
            return currentFolder
        case "..":
            return (currentFolder as NSString).deletingLastPathComponent
        default:
            return path
        }
    }
} 