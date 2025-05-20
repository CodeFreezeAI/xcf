import Foundation

/// A utility class for creating and applying diffs between strings
class XcfSwiftDiff {
    /// Create a diff between two strings
    /// - Parameters:
    ///   - sourceString: The original source string
    ///   - destString: The destination string to compare against
    /// - Returns: A string representation of the diff
    /// - Throws: Errors during diff creation
    static func createDiff(sourceString: String, destString: String) -> String {
        // Simple diff implementation using lines
        let sourceLines = sourceString.components(separatedBy: .newlines)
        let destLines = destString.components(separatedBy: .newlines)
        
        var diffResult = ""
        
        // Compare lines
        let maxLines = max(sourceLines.count, destLines.count)
        for i in 0..<maxLines {
            if i >= sourceLines.count {
                // Line added
                diffResult += "+\(destLines[i])\n"
            } else if i >= destLines.count {
                // Line removed
                diffResult += "-\(sourceLines[i])\n"
            } else if sourceLines[i] != destLines[i] {
                // Line changed
                diffResult += "-\(sourceLines[i])\n+\(destLines[i])\n"
            }
        }
        
        return diffResult.isEmpty ? "No differences found." : diffResult
    }
    
    /// Apply a diff to a source string
    /// - Parameters:
    ///   - sourceString: The original source string
    ///   - destString: The destination string to apply diff to
    /// - Returns: The patched string
    /// - Throws: Errors during diff application
    static func applyDiff(sourceString: String, destString: String) -> String {
        // Simple diff application implementation
        let sourceLines = sourceString.components(separatedBy: .newlines)
        let diffLines = destString.components(separatedBy: .newlines)
        
        var patchedLines = sourceLines
        
        for diffLine in diffLines {
            guard !diffLine.isEmpty else { continue }
            
            let line = String(diffLine.dropFirst())
            switch diffLine.first {
            case "+":
                // Add line
                patchedLines.append(line)
            case "-":
                // Remove line if it exists
                if let index = patchedLines.firstIndex(of: line) {
                    patchedLines.remove(at: index)
                }
            default:
                // Ignore malformed diff lines
                break
            }
        }
        
        return patchedLines.joined(separator: "\n")
    }
    
    /// Create a diff from a document
    /// - Parameters:
    ///   - filePath: Path to the source document
    ///   - destString: The destination string to compare against
    ///   - startLine: Optional start line for partial document diff
    ///   - endLine: Optional end line for partial document diff
    ///   - entireFile: Flag to use entire file
    /// - Returns: A string representation of the diff
    /// - Throws: Errors during file reading or diff creation
    static func createDiffFromDocument(filePath: String, destString: String, startLine: Int? = nil, endLine: Int? = nil, entireFile: Bool = false) throws -> String {
        // Read the document content
        guard let sourceContent = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: filePath) else {
            throw NSError(domain: "XcfSwiftDiff", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to read document"])
        }
        
        // Determine source lines based on parameters
        let sourceLines = sourceContent.components(separatedBy: .newlines)
        var selectedSourceLines: [String]
        
        if entireFile {
            selectedSourceLines = sourceLines
        } else if let start = startLine, let end = endLine {
            // Adjust for 1-indexed line numbers
            let adjustedStart = max(0, start - 1)
            let adjustedEnd = min(sourceLines.count, end)
            selectedSourceLines = Array(sourceLines[adjustedStart..<adjustedEnd])
        } else {
            // Default to entire file if no specific range is provided
            selectedSourceLines = sourceLines
        }
        
        // Convert selected source lines back to string
        let sourceString = selectedSourceLines.joined(separator: "\n")
        
        // Create diff
        return createDiff(sourceString: sourceString, destString: destString)
    }
    
    /// Apply a diff to a document
    /// - Parameters:
    ///   - filePath: Path to the source document
    ///   - destString: The diff to apply
    ///   - startLine: Optional start line for partial document patch
    ///   - endLine: Optional end line for partial document patch
    ///   - entireFile: Flag to use entire file
    /// - Returns: A boolean indicating success
    /// - Throws: Errors during file reading, writing, or diff application
    static func applyDiffToDocument(filePath: String, destString: String, startLine: Int? = nil, endLine: Int? = nil, entireFile: Bool = false) throws -> Bool {
        // Read the document content
        guard let sourceContent = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: filePath) else {
            throw NSError(domain: "XcfSwiftDiff", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to read document"])
        }
        
        // Determine source lines based on parameters
        let sourceLines = sourceContent.components(separatedBy: .newlines)
        var selectedSourceLines: [String]
        var prefixLines: [String] = []
        var suffixLines: [String] = []
        
        if entireFile {
            selectedSourceLines = sourceLines
        } else if let start = startLine, let end = endLine {
            // Adjust for 1-indexed line numbers
            let adjustedStart = max(0, start - 1)
            let adjustedEnd = min(sourceLines.count, end)
            
            // Preserve lines before and after the selected range
            prefixLines = Array(sourceLines[0..<adjustedStart])
            suffixLines = Array(sourceLines[adjustedEnd...])
            selectedSourceLines = Array(sourceLines[adjustedStart..<adjustedEnd])
        } else {
            // Default to entire file if no specific range is provided
            selectedSourceLines = sourceLines
        }
        
        // Convert selected source lines back to string
        let sourceString = selectedSourceLines.joined(separator: "\n")
        
        // Apply diff
        let patchedString = applyDiff(sourceString: sourceString, destString: destString)
        
        // Reconstruct full document
        let fullPatchedContent = (prefixLines + patchedString.components(separatedBy: .newlines) + suffixLines).joined(separator: "\n")
        
        // Write patched content back to document
        return XcfSwiftScript.shared.writeSwiftDocumentWithScriptingBridge(filePath: filePath, content: fullPatchedContent)
    }
}