import Foundation
import MCP
import MultiLineDiff

// MARK: - Diff Tool Handlers

class XcfMcpDiffHandlers {
    
    /// Handles a call to create a diff for a document
    static func handleCreateDiffToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            throw MCPError.invalidParams("Missing Params, fix later")
        }
        
        guard let destString = arguments["destString"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing destinationString")])
        }
        
        guard let sourceString = arguments["sourceString"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing sourceString")])
        }
    
        do {
            let diffHash = try createDiffFromString(original: sourceString, modified: destString)
            return CallTool.Result(content: [.text(diffHash)])

        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
    
    /// Handles a call to the apply_diff tool
    static func handleGetAsciiDiffToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text("I dunno, not done yet.")])
        }
        
        guard let diffHash = arguments["diffHash"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing diff hash")])
        }
        
        do {
            var diff = try getAsciiDiffFromHash(diffHash: diffHash)
            if diff.isEmpty {
                diff = "Having Issues, \(diffHash)"
            }
            return CallTool.Result(content: [.text(diff )])

        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
    
    /// Handles a call to the apply_diff tool
    static func handleApplyDiffToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text("I dunno, not done yet.")])
        }
        
        guard let diffHash = arguments["diffHash"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing diff hash")])
        }
        
        guard let sourceString = arguments["sourceString"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing sourceString")])
        } 
        
        do {
            var diff = try applyDiffFromString(original: sourceString, diffHash: diffHash)
            if diff.isEmpty {
                diff = "Having Issues, \(sourceString) \(diffHash)"
            }
            return CallTool.Result(content: [.text(diff )])

        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
    
    /// Handles a call to create a diff from a document
    static func handleCreateDiffFromDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            throw MCPError.invalidParams("Missing arguments")
        }
        
        guard let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text("Missing filePath parameter")])
        }
        
        guard let modifiedContent = arguments[McpConfig.modifiedContentParamName]?.stringValue else {
            return CallTool.Result(content: [.text("Missing modifiedContent parameter")])
        }
        
        do {
            let diffHash = try createDiffFromDocument(filePath: filePath, modifiedContent: modifiedContent)
            return CallTool.Result(content: [.text(diffHash)])
        } catch {
            throw MCPError.invalidParams(String(format: "Error creating diff from document: %@", error.localizedDescription))
        }
    }
    
    /// Handles a call to apply a diff to a document
    static func handleApplyDiffToDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            throw MCPError.invalidParams("Missing arguments")
        }
        
        guard let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text("Missing filePath parameter")])
        }
        
        guard let diffHash = arguments[McpConfig.diffHashParamName]?.stringValue else {
            return CallTool.Result(content: [.text("Missing diffHash parameter")])
        }
        
        do {
            let diffResult = try getDiffResultFromHash(diffHash: diffHash)
            let success = try applyDiffToDocument(filePath: filePath, operations: diffResult)
            if success {
                return CallTool.Result(content: [.text("Diff applied successfully to document: \(filePath)")])
            } else {
                return CallTool.Result(content: [.text("Failed to apply diff to document: \(filePath)")])
            }
        } catch {
            throw MCPError.invalidParams(String(format: "Error applying diff to document: %@", error.localizedDescription))
        }
    }
    
    /// Handles a call to apply a diff to a document
    static func handleApplyUndoDiffToDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            throw MCPError.invalidParams("Missing arguments")
        }
        
        guard let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text("Missing filePath parameter")])
        }
        
        guard let diffHash = arguments[McpConfig.diffHashParamName]?.stringValue else {
            return CallTool.Result(content: [.text("Missing diffHash parameter")])
        }
        
        do {
            let diffResult = try getDiffResultFromHash(diffHash: diffHash)
            let success = try applyDiffToDocument(filePath: filePath, operations: diffResult)
            if success {
                return CallTool.Result(content: [.text("Diff applied successfully to document: \(filePath)")])
            } else {
                return CallTool.Result(content: [.text("Failed to apply diff to document: \(filePath)")])
            }
        } catch {
            throw MCPError.invalidParams(String(format: "Error applying diff to document: %@", error.localizedDescription))
        }
    }
}
