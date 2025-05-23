import Foundation
import MCP

// MARK: - File System Tool Handlers

class XcfMcpFileSystemHandlers {
    
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
    
    /// Handles a call to the read directory tool
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
} 