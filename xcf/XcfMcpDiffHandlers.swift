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
            let uuid = try createDiffFromString(original: sourceString, modified: destString)
            return CallTool.Result(content: [.text(uuid)])

        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
    
    /// Handles a call to the apply_diff tool
    static func handleApplyDiffToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text("I dunno, not done yet.")])
        }
        
        guard let uuidString = arguments["uuid"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing uuid")])
        }
        
        guard let sourceString = arguments["sourceString"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing sourceString")])
        } 
        
        do {
            var diff = try applyDiffFromString(original: sourceString, UUID: uuidString.lowercased())
            if diff == "" {
                diff = "Having Issues, \(sourceString) \(uuidString.lowercased())"
            }
            return CallTool.Result(content: [.text(diff )])

        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDiff, error.localizedDescription))
        }
    }
} 