import Foundation
import MCP

// MARK: - Xcode Document Tool Handlers

class XcfMcpXcodeDocumentHandlers {
    
    /// Handles opening a document in Xcode
    static func handleOpenDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
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
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Use FuzzyLogicService to resolve the path for better error messages
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        // If there was a warning, include it in the response
        var responseMessage = ""
        if !warning.isEmpty {
            responseMessage += "Warning: \(warning)\n"
        }
        
        if XcfMcpServer.XcfScript.openSwiftDocument(filePath: resolvedPath) {
            responseMessage += McpConfig.documentOpenedSuccessfully
            return CallTool.Result(content: [.text(responseMessage)])
        } else {
            // Check if file exists to provide more specific error
            if !FileManager.default.fileExists(atPath: resolvedPath) {
                responseMessage += "Error: File does not exist: \(resolvedPath)"
            } else if !FileManager.default.isReadableFile(atPath: resolvedPath) {
                responseMessage += "Error: File is not readable: \(resolvedPath)"
            } else {
                responseMessage += String(format: ErrorMessages.errorOpeningFile, resolvedPath)
            }
            return CallTool.Result(content: [.text(responseMessage)])
        }
    }
    
    /// Handles creating a document in Xcode
    static func handleCreateDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        let content = arguments[McpConfig.contentParamName]?.stringValue ?? ""
        
        if XcfMcpServer.XcfScript.createSwiftDocumentWithFileManager(filePath: filePath, content: content) {
            return CallTool.Result(content: [.text(McpConfig.documentCreatedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorCreatingFile, filePath))])
        }
    }
    
    /// Handles reading a document from Xcode
    static func handleReadDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
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
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Use FuzzyLogicService to resolve the path
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
    
        if let content = XcfMcpServer.XcfScript.readSwiftDocumentWithFileManager(filePath: resolvedPath) {
            return CallTool.Result(content: [.text(content)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, filePath))])
        }
    }
    
    /// Handles saving a document in Xcode
    static func handleSaveDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        if XcfMcpServer.XcfScript.writeSwiftDocumentWithFileManager(filePath: filePath, content: "") {
            return CallTool.Result(content: [.text(McpConfig.documentSavedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorWritingFile, filePath))])
        }
    }
    
    /// Handles closing a document in Xcode
    static func handleCloseDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        // Debug: Print out the entire params
        
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
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
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Get saving option, handling both boolean and string representations
        let savingParam: Bool
        if let boolValue = arguments["saving"]?.boolValue {
            savingParam = boolValue
        } else if let stringValue = arguments["saving"]?.stringValue {
            // Handle string representations of boolean
            savingParam = ["true", "yes", "1"].contains(stringValue.lowercased())
        } else {
            return CallTool.Result(content: [.text("Missing 'saving' parameter")])
        }
        
        // Convert boolean to XcodeSaveOptions
        let saveOptions: XcodeSaveOptions = savingParam ? .yes : .no
                
        if XcfMcpServer.XcfScript.closeSwiftDocument(filePath: filePath, xcSaveOptions: saveOptions) {
            return CallTool.Result(content: [.text(McpConfig.documentClosedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorClosingFile, filePath))])
        }
    }
} 
