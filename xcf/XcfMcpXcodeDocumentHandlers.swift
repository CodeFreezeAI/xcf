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
        
        if XcfMcpServer.XcfScript.openSwiftDocument(filePath: filePath) {
            return CallTool.Result(content: [.text(McpConfig.documentOpenedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorOpeningFile, filePath))])
        }
    }
    
    /// Handles creating a document in Xcode
    static func handleCreateDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        let content = arguments[McpConfig.contentParamName]?.stringValue ?? ""
        
        if XcfMcpServer.XcfScript.createSwiftDocumentWithScriptingBridge(filePath: filePath, content: content) {
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
        
        // If there was a warning, print it
        if !warning.isEmpty {
            print(warning)
        }
        
        if let content = XcfMcpServer.XcfScript.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) {
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
        
        if XcfMcpServer.XcfScript.writeSwiftDocumentWithScriptingBridge(filePath: filePath, content: "") {
            return CallTool.Result(content: [.text(McpConfig.documentSavedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorWritingFile, filePath))])
        }
    }
    
    /// Handles closing a document in Xcode
    static func handleCloseDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        // Debug: Print out the entire params
        print("Close Doc Tool Call Params: \(params)")
        
        guard let arguments = params.arguments else {
            print("No arguments provided")
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Debug: Print out the arguments
        print("Arguments: \(arguments)")
        
        // Try to get filePath from arguments in two ways:
        // 1. As a named parameter (filePath=...)
        // 2. As a direct argument (first argument after command)
        let filePath: String
        if let namedPath = arguments[McpConfig.filePathParamName]?.stringValue {
            filePath = namedPath
            print("FilePath from named parameter: \(filePath)")
        } else if let firstArg = arguments.first?.value.stringValue {
            filePath = firstArg
            print("FilePath from first argument: \(filePath)")
        } else {
            print("No filePath found")
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Get saving option, handling both boolean and string representations
        let savingParam: Bool
        if let boolValue = arguments["saving"]?.boolValue {
            savingParam = boolValue
            print("Saving parameter (bool): \(savingParam)")
        } else if let stringValue = arguments["saving"]?.stringValue {
            // Handle string representations of boolean
            savingParam = ["true", "yes", "1"].contains(stringValue.lowercased())
            print("Saving parameter (string): \(stringValue), parsed as: \(savingParam)")
        } else {
            print("No saving parameter found")
            return CallTool.Result(content: [.text("Missing 'saving' parameter")])
        }
        
        // Convert boolean to XcodeSaveOptions
        let saveOptions: XcodeSaveOptions = savingParam ? .yes : .no
        
        print("Attempting to close document: \(filePath) with save options: \(saveOptions)")
        
        if XcfMcpServer.XcfScript.closeSwiftDocument(filePath: filePath, xcSaveOptions: saveOptions) {
            print("Document closed successfully")
            return CallTool.Result(content: [.text(McpConfig.documentClosedSuccessfully)])
        } else {
            print("Failed to close document")
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorClosingFile, filePath))])
        }
    }
} 