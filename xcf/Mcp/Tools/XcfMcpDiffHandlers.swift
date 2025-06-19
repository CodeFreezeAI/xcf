import Foundation
import MCP
import MultiLineDiff

// MARK: - Diff Tool Handlers

class XcfMcpDiffHandlers {
    
    /// Handles a call to create a diff for a document
    static func handleCreateDiffToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        let (arguments, errorResult) = XcfMcpToolHelpers.extractArguments(from: params, errorMessage: "Missing Params, fix later")
        if let errorResult = errorResult { throw MCPError.invalidParams("Missing Params, fix later") }
        
        let (destString, destError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: "destString", errorMessage: "Missing destinationString")
        if let destError = destError { return destError }
        
        let (sourceString, sourceError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: "sourceString", errorMessage: "Missing sourceString")
        if let sourceError = sourceError { return sourceError }
    
        do {
            let diffHash = try createDiffFromString(original: sourceString!, modified: destString!)
            return XcfMcpToolHelpers.textResult(diffHash)
        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
    
    /// Handles a call to the apply_diff tool
    static func handleApplyDiffToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        let (arguments, _) = XcfMcpToolHelpers.extractArguments(from: params)
        if arguments == nil {
            return XcfMcpToolHelpers.textResult("I dunno, not done yet.")
        }
        
        let (diffHash, hashError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: "diffHash", errorMessage: "Missing diff hash")
        if let hashError = hashError { return hashError }
        
        let (sourceString, sourceError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: "sourceString", errorMessage: "Missing sourceString")
        if let sourceError = sourceError { return sourceError }
        
        do {
            var diff = try applyDiffFromString(original: sourceString!, diffHash: diffHash!)
            if diff == "" {
                diff = "Having Issues, \(sourceString!) \(diffHash!)"
            }
            return XcfMcpToolHelpers.textResult(diff)
        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
    
    /// Handles a call to create a diff from a document
    static func handleCreateDiffFromDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        let (arguments, errorResult) = XcfMcpToolHelpers.extractArguments(from: params)
        if let errorResult = errorResult { throw MCPError.invalidParams("Missing arguments") }
        
        let (filePath, pathError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: McpConfig.filePathParamName, errorMessage: "Missing filePath parameter")
        if let pathError = pathError { return pathError }
        
        let (modifiedContent, contentError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: McpConfig.modifiedContentParamName, errorMessage: "Missing modifiedContent parameter")
        if let contentError = contentError { return contentError }
        
        do {
            let diffHash = try createDiffFromDocument(filePath: filePath!, modifiedContent: modifiedContent!)
            return XcfMcpToolHelpers.textResult(diffHash)
        } catch {
            throw MCPError.invalidParams(String(format: "Error creating diff from document: %@", error.localizedDescription))
        }
    }
    
    /// Handles a call to apply a diff to a document
    static func handleApplyDiffToDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        let (arguments, errorResult) = XcfMcpToolHelpers.extractArguments(from: params)
        if let errorResult = errorResult { throw MCPError.invalidParams("Missing arguments") }
        
        let (filePath, pathError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: McpConfig.filePathParamName, errorMessage: "Missing filePath parameter")
        if let pathError = pathError { return pathError }
        
        let (diffHash, hashError) = XcfMcpToolHelpers.extractStringParam(from: arguments!, paramName: McpConfig.diffHashParamName, errorMessage: "Missing diffHash parameter")
        if let hashError = hashError { return hashError }
        
        do {
            let success = try applyDiffToDocument(filePath: filePath!, diffHash: diffHash!)
            if success {
                return XcfMcpToolHelpers.textResult("Diff applied successfully to document: \(filePath!)")
            } else {
                return XcfMcpToolHelpers.textResult("Failed to apply diff to document: \(filePath!)")
            }
        } catch {
            throw MCPError.invalidParams(String(format: "Error applying diff to document: %@", error.localizedDescription))
        }
    }
} 
