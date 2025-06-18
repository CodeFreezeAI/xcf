import Foundation
import MCP

// MARK: - Code Snippet Handlers

class XcfMcpCodeSnippetHandlers {
    
    // MARK: - Code Snippet Handling
    
    /// Handles code snippet extraction
    static func handleCodeSnippet(filePath: String, entireFile: Bool, startLine: Int? = nil, endLine: Int? = nil) -> CallTool.Result {
        // Resolve the file path using multiple strategies
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        // Validate file path - use the resolved path
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, "File not found. Tried searching for \(filePath) in multiple locations."))])
        }
        
        // Add warning message if there is one
        var warningText = ""
        if !warning.isEmpty {
            warningText = warning + Format.newLine + Format.newLine
        }
        
        if entireFile {
            return handleEntireFileSnippet(filePath: resolvedPath, warning: warningText)
        } else if let startLine = startLine, let endLine = endLine {
            return handleLineRangeSnippet(filePath: resolvedPath, startLine: startLine, endLine: endLine, warning: warningText)
        } else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
        }
    }
    
    /// Handles extracting an entire file as a code snippet
    static func handleEntireFileSnippet(filePath: String, warning: String = "") -> CallTool.Result {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            let language = FileFinder.determineLanguage(from: filePath)
            return CallTool.Result(content: [.text(warning + String(format: McpConfig.codeBlockFormat, language, fileContents))])
        } catch {
            return CallTool.Result(content: [.text(warning + String(format: ErrorMessages.errorReadingFile, error.localizedDescription))])
        }
    }
    
    /// Handles extracting a range of lines as a code snippet
    static func handleLineRangeSnippet(filePath: String, startLine: Int, endLine: Int, warning: String = "") -> CallTool.Result {
        let (snippet, language) = CaptureSnippet.getCodeSnippet(
            filePath: filePath,
            startLine: startLine,
            endLine: endLine
        )
        
        return CallTool.Result(content: [.text(warning + String(format: McpConfig.codeBlockFormat, language, snippet))])
    }
    
    /// Handles extracting a code snippet for the analyzer tool
    static func handleAnalyzerCodeSnippet(filePath: String, entireFile: Bool, startLine: Int? = nil, endLine: Int? = nil) -> CallTool.Result {
        // Use SwiftAnalyzer to analyze the code
        let (analysisResult, language) = SwiftAnalyzer.analyzeCode(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
        
        // Format the result based on the language
        if language == "markdown" {
            // Markdown output doesn't need code block formatting
            return CallTool.Result(content: [.text(analysisResult)])
        } else {
            // Format as code block
            return CallTool.Result(content: [.text(String(format: McpConfig.codeBlockFormat, language, analysisResult))])
        }
    }
    
    /// Creates a message containing a code snippet
    static func createCodeSnippetMessage(filePath: String) throws -> Prompt.Message {
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        let language = FileFinder.determineLanguage(from: filePath)
        let resourceUri = "\(McpConfig.fileContentsResourceURI)/\(filePath)"
        
        return Prompt.Message(
            role: .user,
            content: .resource(
                uri: resourceUri,
                mimeType: McpConfig.plainTextMimeType,
                text: String(format: McpConfig.codeBlockFormat, language, fileContents),
                blob: nil
            )
        )
    }
} 