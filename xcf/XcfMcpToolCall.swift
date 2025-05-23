//
//  XcfMcpHandlers.swift
//  xcf
//
//  Created by Todd Bruss on 5/17/25
//

import Foundation
import MCP
import MultiLineDiff

typealias StringIndex = String.Index

extension XcfMcpServer {
    
    /// Handles a call to the xcf tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the xcf tool call
    /// - Throws: Error if action is missing
    static func handleXcfToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result {
        if let action = params.arguments?[McpConfig.actionParamName]?.stringValue {
            print(String(format: McpConfig.actionFound, action))
            return CallTool.Result(content: [.text(await XcfActionHandler.handleAction(action: action))])
        } else {
            print(McpConfig.noActionFound)
            // If no action specified, return the help information
            return CallTool.Result(content: [.text(await XcfActionHandler.handleAction(action: Actions.help))])
        }
    }
    
    /// Handles a call to the snippet tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the snippet tool call
    /// - Throws: Error if filePath is missing
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
        
        return handleCodeSnippet(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
    
    /// Handles a call to the quick help tool (xcf actions only)
    static func handleQuickHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(HelpText.basic)])
    }
    
    /// Handles a call to the regular help tool
    static func handleHelpToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(HelpText.detailed)])
    }
    
    /// Handles a call to the tools reference tool
    static func handleToolsReferenceToolCall(_ params: CallTool.Parameters) -> CallTool.Result {
        return CallTool.Result(content: [.text(HelpText.toolsReference)])
    }
    
    /// Handles a call to the write file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the write file tool call
    /// - Throws: Error if filePath or content is missing
    static func handleWriteFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Try to get filePath and content from arguments
        let filePath: String
        let content: String
        
        // First try named parameters
        if let namedPath = arguments["filePath"]?.stringValue,
           let namedContent = arguments["content"]?.stringValue {
            filePath = namedPath
            content = namedContent
        }
        // Then try positional parameters
        else if let firstArg = arguments.first?.value.stringValue,
                let secondArg = arguments.values.dropFirst().first?.stringValue {
            filePath = firstArg
            content = secondArg
        }
        else {
            return CallTool.Result(content: [.text("Missing filePath or content parameters")])
        }
        
        do {
            try XcfFileManager.writeFile(content: content, to: filePath)
            return CallTool.Result(content: [.text("Successfully wrote content to file: \(filePath)")])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorWritingFile, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the read file tool
    static func handleReadFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
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
        
        // Get and verify the project directory
        guard let projectDir = XcfXcodeProjectManager.shared.currentFolder else {
            return CallTool.Result(content: [.text("No current project directory set")])
        }
        
        // Determine the full path
        let fullPath = FuzzyLogicService.expandPath(filePath, relativeTo: projectDir)
        
        do {
            let fileContents = try String(contentsOfFile: fullPath, encoding: .utf8)
            return CallTool.Result(content: [.text(fileContents)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the change directory tool
    static func handleCdDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        // Get the current folder first as we'll need it
        guard let currentFolder = XcfXcodeProjectManager.shared.currentFolder else {
            return CallTool.Result(content: [.text("No current folder is set. Please select a project first.")])
        }
        
        // If no arguments provided, show current directory
        if params.arguments == nil || params.arguments?.isEmpty == true {
            return CallTool.Result(content: [.text("Current directory: \(currentFolder)")])
        }
        
        let arguments = params.arguments!
        
        // Determine the directory to change to
        let directoryPath: String
        if let namedPath = arguments[McpConfig.directoryPathParamName]?.stringValue {
            // Case 1: Named parameter
            if namedPath == "." {
                directoryPath = currentFolder
            } else if namedPath == ".." {
                directoryPath = (currentFolder as NSString).deletingLastPathComponent
            } else {
                directoryPath = namedPath
            }
        } else if let firstArg = arguments.first?.value.stringValue {
            // Case 2: First argument
            if firstArg == "." {
                directoryPath = currentFolder
            } else if firstArg == ".." {
                directoryPath = (currentFolder as NSString).deletingLastPathComponent
            } else {
                directoryPath = firstArg
            }
        } else {
            // Default to showing current directory
            return CallTool.Result(content: [.text("Current directory: \(currentFolder)")])
        }
        
        // Security check
        let (allowed, resolvedPath, error) = SecurityManager.shared.isDirectoryOperationAllowed(directoryPath, operation: "change to")
        if !allowed {
            return CallTool.Result(content: [.text(error ?? "Access denied")])
        }
        
        do {
            // Update both FileManager's current directory and XcfXcodeProjectManager's currentFolder
            try XcfFileManager.changeDirectory(to: resolvedPath)
            XcfXcodeProjectManager.shared.currentFolder = resolvedPath
            return CallTool.Result(content: [.text("Changed directory to: \(resolvedPath)")])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorChangingDirectory, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the edit file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the edit file tool call
    /// - Throws: Error if filePath, start line, end line, or replacement content is missing
    static func handleEditFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
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
        
        // Get startLine as the second argument or from the named parameter
        let startLine: Int
        if let namedStartLine = arguments[McpConfig.startLineParamName]?.intValue {
            startLine = namedStartLine
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 2, let secondArg = arguments[keys[1]]?.stringValue, let line = Int(secondArg) {
                startLine = line
            } else {
                return CallTool.Result(content: [.text("Missing startLine parameter")])
            }
        }
        
        // Get endLine as the third argument or from the named parameter
        let endLine: Int
        if let namedEndLine = arguments[McpConfig.endLineParamName]?.intValue {
            endLine = namedEndLine
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 3, let thirdArg = arguments[keys[2]]?.stringValue, let line = Int(thirdArg) {
                endLine = line
            } else {
                return CallTool.Result(content: [.text("Missing endLine parameter")])
            }
        }
        
        // Get replacement content as the fourth argument or from the named parameter
        let replacementContent: String
        if let namedReplacement = arguments[McpConfig.replacementParamName]?.stringValue {
            replacementContent = namedReplacement
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 4, let fourthArg = arguments[keys[3]]?.stringValue {
                replacementContent = fourthArg
            } else {
                return CallTool.Result(content: [.text("Missing replacement content parameter")])
            }
        }
        
        do {
            let (content, _) = try XcfFileManager.editSwiftDocument(filePath: filePath, startLine: startLine, endLine: endLine, replacement: replacementContent)
            return CallTool.Result(content: [.text(content)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorEditingFile, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the delete file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the delete file tool call
    /// - Throws: Error if filePath is missing
    static func handleDeleteFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
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
        
        do {
            try XcfFileManager.deleteFile(at: filePath)
            return CallTool.Result(content: [.text(McpConfig.fileDeletedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorDeletingFile, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the add directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the add directory tool call
    /// - Throws: Error if directory path is missing
    static func handleAddDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingDirectoryPathParamError)])
        }
        
        do {
            try XcfFileManager.createDirectory(at: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryCreatedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorCreatingDirectory, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the remove directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the remove directory tool call
    /// - Throws: Error if directory path is missing
    static func handleRmDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingDirectoryPathParamError)])
        }
        
        do {
            try XcfFileManager.removeDirectory(at: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryRemovedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorRemovingDirectory, error.localizedDescription))])
        }
    }
    
    // MARK: - Resource Request Handling
    
    /// Handles a resource request
    /// - Parameter params: The parameters for the resource request
    /// - Returns: The result of the resource request
    /// - Throws: Invalid parameter errors or resource access errors
    static func handleResourceRequest(_ params: ReadResource.Parameters) async throws -> ReadResource.Result {
        switch params.uri {
        case McpConfig.xcodeProjResourceURI:
            return try await handleXcodeProjectsResource()
            
        case McpConfig.fileContentsResourceURI:
            return try handleFileContentsResource(uri: params.uri)
            
        case McpConfig.buildResultsResourceURI:
            return try await handleBuildResultsResource()
            
        default:
            throw MCPError.invalidParams(String(format: McpConfig.unknownResourceUriError, params.uri))
        }
    }
    
    /// Handles a request for the Xcode projects resource
    /// - Returns: The Xcode projects resource content
    static func handleXcodeProjectsResource() async throws -> ReadResource.Result {
        let projects = await XcfActionHandler.getSortedXcodeProjects()
        let content = Resource.Content.text(
            projects.joined(separator: McpConfig.newLineSeparator),
            uri: McpConfig.xcodeProjResourceURI
        )
        return ReadResource.Result(contents: [content])
    }
    
    /// Handles a request for the build results resource
    /// - Returns: The build results resource content
    /// - Throws: Error if no project is selected
    static func handleBuildResultsResource() async throws -> ReadResource.Result {
        guard let currentProject = await XcfActionHandler.getCurrentProject() else {
            throw MCPError.invalidParams(ErrorMessages.noProjectSelected)
        }
        
        let buildResults = XcfScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        let content = Resource.Content.text(
            buildResults,
            uri: McpConfig.buildResultsResourceURI
        )
        return ReadResource.Result(contents: [content])
    }
    
    // MARK: - Prompt Request Handling
    
    /// Handles a prompt request
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The result of the prompt request
    /// - Throws: Invalid parameter errors
    static func handlePromptRequest(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        switch params.name {
        case McpConfig.buildPromptName:
            return handleBuildPrompt(params)
            
        case McpConfig.runPromptName:
            return handleRunPrompt(params)
            
        case McpConfig.analyzeCodePromptName:
            return try handleAnalyzeCodePrompt(params)
            
        default:
            throw MCPError.invalidParams(String(format: McpConfig.unknownPromptNameError, params.name))
        }
    }
    
    /// Handles a request for the build project prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The build project prompt messages
    static func handleBuildPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? McpConfig.projectPathPlaceholder
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: String(format: McpConfig.buildProjectTemplate, projectPath)))
        ]
        
        return GetPrompt.Result(description: McpConfig.buildProjectResultDesc, messages: messages)
    }
    
    /// Handles a request for the run project prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The run project prompt messages
    static func handleRunPrompt(_ params: GetPrompt.Parameters) -> GetPrompt.Result {
        // Get project path from arguments or use placeholder
        let projectPath = params.arguments?[McpConfig.projectPathArgName]?.stringValue ?? McpConfig.projectPathPlaceholder
        
        let messages: [Prompt.Message] = [
            .init(role: .user, content: .text(text: String(format: McpConfig.runProjectTemplate, projectPath)))
        ]
        
        return GetPrompt.Result(description: McpConfig.runProjectResultDesc, messages: messages)
    }
    
    /// Handles a request for the analyze code prompt
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The analyze code prompt messages
    /// - Throws: File access errors
    static func handleAnalyzeCodePrompt(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result {
        // Get file path from arguments or use placeholder
        let filePath = params.arguments?[McpConfig.filePathArgName]?.stringValue ?? McpConfig.filePathPlaceholder
        let includeSnippet = params.arguments?[McpConfig.includeSnippetArgName]?.boolValue ?? false
        
        // Create the base message
        let baseMessage = Prompt.Message(
            role: .user,
            content: .text(text: String(format: McpConfig.analyzeCodeTemplate, filePath))
        )
        
        var messages: [Prompt.Message] = [baseMessage]
        
        // Add code snippet if requested
        if includeSnippet {
            if let snippetMessage = try? createCodeSnippetMessage(filePath: filePath) {
                messages.append(snippetMessage)
            }
            // If snippet creation fails, we still return the base message
        }
        
        return GetPrompt.Result(description: McpConfig.analyzeCodeResultDesc, messages: messages)
    }
    
    /// Creates a message containing a code snippet
    /// - Parameter filePath: Path to the file to extract code from
    /// - Returns: A message containing the code snippet
    /// - Throws: File access errors
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
    
    /// Handles code snippet extraction
    /// - Parameters:
    ///   - filePath: Path to the file to extract from
    ///   - entireFile: Whether to extract the entire file
    ///   - startLine: The line to start extraction from
    ///   - endLine: The line to end extraction at
    /// - Returns: The extracted code snippet
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
    /// - Parameter filePath: Path to the file to extract
    /// - Returns: The extracted code snippet
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
    /// - Parameters:
    ///   - filePath: Path to the file to extract from
    ///   - startLine: The line to start extraction from
    ///   - endLine: The line to end extraction at
    /// - Returns: The extracted code snippet
    static func handleLineRangeSnippet(filePath: String, startLine: Int, endLine: Int, warning: String = "") -> CallTool.Result {
        let (snippet, language) = CaptureSnippet.getCodeSnippet(
            filePath: filePath,
            startLine: startLine,
            endLine: endLine
        )
        
        return CallTool.Result(content: [.text(warning + String(format: McpConfig.codeBlockFormat, language, snippet))])
    }
    
    /// Handles extracting a code snippet for the analyzer tool
    /// - Parameters:
    ///   - filePath: Path to the file to extract from
    ///   - entireFile: Whether to extract the entire file
    ///   - startLine: The line to start extraction from
    ///   - endLine: The line to end extraction at
    /// - Returns: The extracted code snippet
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
    
    /// Handles a call to the analyzer tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the analyzer tool call
    /// - Throws: Error if filePath is missing
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
        
        return handleAnalyzerCodeSnippet(
            filePath: filePath,
            entireFile: entireFile,
            startLine: startLine,
            endLine: endLine
        )
    }
    
    // MARK: - Utility Methods
    
    /// Extracts a file path from a URI query string
    /// - Parameter uri: The URI to extract the file path from
    /// - Returns: The extracted file path, or nil if not found
    static func extractFilePathFromUri(_ uri: String) -> String? {
        let uriComponents = uri.components(separatedBy: "?")
        guard uriComponents.count > 1,
              let queryItems = URLComponents(string: "?" + uriComponents[1])?.queryItems,
              let filePathItem = queryItems.first(where: { $0.name == McpConfig.filePathQueryParam }),
              let filePath = filePathItem.value,
              !filePath.isEmpty else {
            return nil
        }
        return filePath
    }
    
    /// Handles a request for the file contents resource
    /// - Parameter uri: The URI of the resource request
    /// - Returns: The file contents resource
    /// - Throws: Invalid parameter errors or file access errors
    static func handleFileContentsResource(uri: String) throws -> ReadResource.Result {
        guard let filePath = extractFilePathFromUri(uri) else {
            throw MCPError.invalidParams(McpConfig.missingFilePathParamError)
        }
        
        do {
            let (fileContents, warning) = try XcfFileManager.readFile(at: filePath)
            let content = Resource.Content.text(
                warning.isEmpty ? fileContents : warning + "\n\n" + fileContents,
                uri: "\(McpConfig.fileContentsResourceURI)/\(filePath)",
                mimeType: McpConfig.plainTextMimeType
            )
            return ReadResource.Result(contents: [content])
        } catch let error as NSError {
            throw MCPError.invalidParams(error.localizedDescription)
        }
    }
    
    /// Handles a call to the read directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the read directory tool call
    /// - Throws: Error if directory cannot be read
    static func handleReadDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        // Get the current folder first as we'll need it
        guard let currentFolder = XcfXcodeProjectManager.shared.currentFolder else {
            return CallTool.Result(content: [.text("No current folder is set. Please select a project first.")])
        }
        
        let arguments = params.arguments!
        
        // Determine the directory to read
        let directoryPath: String
        if let namedPath = arguments[McpConfig.directoryPathParamName]?.stringValue {
            // Case 1: Named parameter
            if namedPath == "." || params.arguments == nil || params.arguments?.isEmpty == true {
                directoryPath = currentFolder
            } else if namedPath == ".." {
                directoryPath = (currentFolder as NSString).deletingLastPathComponent
            } else if namedPath == "cd" {
                do {
                    let filePaths = try XcfFileManager.readDirectory(at: currentFolder, fileExtension: nil)
                    let content = filePaths.joined(separator: McpConfig.newLineSeparator)
                    return CallTool.Result(content: [.text(content)])
                } catch {
                    return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingDirectory, error.localizedDescription))])
                }
            } else {
                directoryPath = namedPath
            }
        } else if let firstArg = arguments.first?.value.stringValue {
            // Case 2: First argument
            if firstArg == "." {
                directoryPath = currentFolder
            } else if firstArg == ".." {
                directoryPath = (currentFolder as NSString).deletingLastPathComponent
            } else {
                directoryPath = firstArg
            }
        } else {
            // Default to current folder
            directoryPath = currentFolder
        }
        
        // Security check
        let (allowed, resolvedPath, error) = SecurityManager.shared.isDirectoryOperationAllowed(directoryPath, operation: "read")
        if !allowed {
            return CallTool.Result(content: [.text(error ?? "Access denied")])
        }
        
        // Get optional file extension filter
        let fileExtension: String?
        if let namedExt = arguments[McpConfig.fileExtensionParamName]?.stringValue {
            fileExtension = namedExt.isEmpty ? nil : namedExt
        } else {
            let keys = arguments.keys.sorted()
            if keys.count >= 2 {
                fileExtension = arguments[keys[1]]?.stringValue
            } else {
                fileExtension = nil
            }
        }
        
        do {
            let filePaths = try XcfFileManager.readDirectory(at: resolvedPath, fileExtension: fileExtension)
            let content = filePaths.joined(separator: McpConfig.newLineSeparator)
            return CallTool.Result(content: [.text(content)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingDirectory, error.localizedDescription))])
        }
    }
    
    /// Handles a call to the create directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the create directory tool call
    /// - Throws: MCPError for invalid parameters or FileManager errors
    static func handleCreateDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let directoryPath = arguments[McpConfig.directoryPathParamName]?.stringValue else {
            throw MCPError.invalidParams(McpConfig.missingDirectoryPathParamError)
        }
        
        do {
            try XcfFileManager.createDirectory(at: directoryPath)
            return CallTool.Result(content: [.text(McpConfig.directoryCreatedSuccessfully)])
        } catch {
            throw MCPError.invalidParams(String(format: ErrorMessages.errorCreatingDirectory, error.localizedDescription))
        }
    }
    
    /// Handles a call to the create file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the create file tool call
    /// - Throws: Error if filePath or content is missing
    static func handleCreateFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue,
              let content = arguments[McpConfig.contentParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        do {
            try XcfFileManager.createFile(at: filePath, content: content)
            return CallTool.Result(content: [.text(McpConfig.fileCreatedSuccessfully)])
        } catch {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorCreatingFile, error.localizedDescription))])
        }
    }
    
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
        
        if XcfScript.openSwiftDocument(filePath: filePath) {
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
        
        if XcfScript.createSwiftDocumentWithScriptingBridge(filePath: filePath, content: content) {
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
        
        if let content = XcfScript.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) {
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
        
        if XcfScript.writeSwiftDocumentWithScriptingBridge(filePath: filePath, content: "") {
            return CallTool.Result(content: [.text(McpConfig.documentSavedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorWritingFile, filePath))])
        }
    }
    
    /// Handles editing a document in Xcode
    static func handleEditDocToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
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
        
        // Validate other required parameters
        guard let startLine = arguments[McpConfig.startLineParamName]?.intValue,
              let endLine = arguments[McpConfig.endLineParamName]?.intValue,
              let replacement = arguments[McpConfig.replacementParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingLineParamsError)])
        }
        
        if XcfScript.editSwiftDocumentWithScriptingBridge(filePath: filePath, startLine: startLine, endLine: endLine, replacement: replacement) {
            return CallTool.Result(content: [.text(McpConfig.documentEditedSuccessfully)])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorEditingFile, filePath))])
        }
    }
    
    /// Handles a call to the move file tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the move file tool call
    /// - Throws: Error if sourcePath or destinationPath is missing
    static func handleMoveFileToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text("Missing source and destination file parameters")])
        }
        
        // Try to get source and destination paths from arguments
        // First try named parameters, then positional
        let sourcePath: String
        let destinationPath: String
        
        if let namedSource = arguments["sourcePath"]?.stringValue,
           let namedDest = arguments["destinationPath"]?.stringValue {
            // Case 1: Named parameters
            sourcePath = namedSource
            destinationPath = namedDest
        } else {
            // Case 2: Positional parameters
            let keys = arguments.keys.sorted()
            if keys.count >= 2,
               let firstArg = arguments[keys[0]]?.stringValue,
               let secondArg = arguments[keys[1]]?.stringValue {
                sourcePath = firstArg
                destinationPath = secondArg
            } else {
                return CallTool.Result(content: [.text("Missing source and destination file parameters. Usage: move_file source_file destination_file")])
            }
        }
        
        do {
            try XcfFileManager.moveFile(from: sourcePath, to: destinationPath)
            return CallTool.Result(content: [.text("Successfully moved file from \(sourcePath) to \(destinationPath)")])
        } catch {
            return CallTool.Result(content: [.text(String(format: "Error moving file: %@", error.localizedDescription))])
        }
    }
    
    /// Handles a call to the move directory tool
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the move directory tool call
    /// - Throws: Error if sourcePath or destinationPath is missing
    static func handleMoveDirToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments else {
            return CallTool.Result(content: [.text("Missing source and destination directory parameters")])
        }
        
        // Try to get source and destination paths from arguments
        // First try named parameters, then positional
        let sourcePath: String
        let destinationPath: String
        
        if let namedSource = arguments["sourcePath"]?.stringValue,
           let namedDest = arguments["destinationPath"]?.stringValue {
            // Case 1: Named parameters
            sourcePath = namedSource
            destinationPath = namedDest
        } else {
            // Case 2: Positional parameters
            let keys = arguments.keys.sorted()
            if keys.count >= 2,
               let firstArg = arguments[keys[0]]?.stringValue,
               let secondArg = arguments[keys[1]]?.stringValue {
                sourcePath = firstArg
                destinationPath = secondArg
            } else {
                return CallTool.Result(content: [.text("Missing source and destination directory parameters. Usage: move_dir source_directory destination_directory")])
            }
        }
        
        do {
            try XcfFileManager.moveDirectory(from: sourcePath, to: destinationPath)
            return CallTool.Result(content: [.text("Successfully moved directory from \(sourcePath) to \(destinationPath)")])
        } catch {
            return CallTool.Result(content: [.text(String(format: "Error moving directory: %@", error.localizedDescription))])
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
        
        if XcfScript.closeSwiftDocument(filePath: filePath, xcSaveOptions: saveOptions) {
            print("Document closed successfully")
            return CallTool.Result(content: [.text(McpConfig.documentClosedSuccessfully)])
        } else {
            print("Failed to close document")
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorClosingFile, filePath))])
        }
    }
    
    /// Handles a call to calculate the end line of a document
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the end line calculation tool call
    /// - Throws: Error if filePath is missing
    static func handleCalculateEndLineToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue else {
            return CallTool.Result(content: [.text(McpConfig.missingFilePathParamError)])
        }
        
        // Resolve the file path using multiple strategies
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        // Validate file path
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, "File not found. Tried searching for \(filePath) in multiple locations."))])
        }
        
        // Calculate end line
        if let endLine = XcfSwiftScript.shared.calculateDocumentEndLine(filePath: resolvedPath) {
            return CallTool.Result(content: [.text(warning + "Total lines in document: \(endLine)")])
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, "Unable to calculate end line"))])
        }
    }
    
    /// Handles a call to search lines in a document
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the search lines tool call
    /// - Throws: Error if filePath or searchText is missing
    static func handleSearchLinesToolCall(_ params: CallTool.Parameters) throws -> CallTool.Result {
        guard let arguments = params.arguments,
              let filePath = arguments[McpConfig.filePathParamName]?.stringValue,
              let searchText = arguments["searchText"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing filePath or searchText parameters")])
        }
        
        // Resolve the file path using multiple strategies
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        // Validate file path
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, "File not found. Tried searching for \(filePath) in multiple locations."))])
        }
        
        // Determine case sensitivity
        let caseSensitive = arguments["caseSensitive"]?.boolValue ?? false
        
        // Search lines
        if let matchedLines = XcfSwiftScript.shared.searchLinesInDocument(filePath: resolvedPath, searchText: searchText, caseSensitive: caseSensitive) {
            if matchedLines.isEmpty {
                return CallTool.Result(content: [.text(warning + "No lines found containing '\(searchText)'")])
            } else {
                let lineNumbers = matchedLines.map { String($0) }.joined(separator: ", ")
                return CallTool.Result(content: [.text(warning + "Lines containing '\(searchText)': \(lineNumbers)")])
            }
        } else {
            return CallTool.Result(content: [.text(String(format: ErrorMessages.errorReadingFile, "Unable to search lines"))])
        }
    }
    
    /// Handles a call to create a diff for a document
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the create diff tool call
    /// - Throws: MCPError for invalid parameters or diff creation errors
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
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the apply_diff tool call
    /// - Throws: Error if filePath or operations is missing
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


