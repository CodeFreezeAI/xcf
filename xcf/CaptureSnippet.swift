//
//  CodeSnippets.swift
//  xcf
//
//  Created by Todd Bruss on 5/6/25.
//

import Foundation

struct CaptureSnippet {
    static func getCodeSnippet(filePath: String, startLine: Int, endLine: Int, entireFile: Bool = false) -> (String, String) {
        var snippet = ""
        let language = determineLanguage(from: filePath)
        
        // Try to find the file using multiple strategies
        let resolvedPath = resolveFilePath(filePath)
        
        do {
            let fileContents = try String(contentsOfFile: resolvedPath, encoding: .utf8)
            
            if entireFile {
                // If entireFile is true, return the whole file content regardless of line numbers
                return (fileContents, language)
            }
            
            let lines = fileContents.components(separatedBy: Format.newlinesCharSet())
            
            // Validate line numbers
            if startLine < 1 || endLine > lines.count || endLine < startLine {
                return (ErrorMessages.invalidLineNumbers, language)
            }
            
            // Extract the snippet
            for i in startLine...min(endLine, lines.count) {
                if i > startLine {
                    snippet += Format.newLine
                }
                if i-1 < lines.count {
                    snippet += lines[i-1]
                }
            }
        } catch {
            return (String(format: ErrorMessages.errorReadingFile, error.localizedDescription), language)
        }
        
        return (snippet, language)
    }
    
    /// Attempts to intelligently resolve a file path using multiple strategies
    /// - Parameter originalPath: The original path provided
    /// - Returns: The resolved path, or the original if no resolution strategies succeed
    static func resolveFilePath(_ originalPath: String) -> String {
        let fileManager = FileManager.default
        
        // Strategy 1: Try the original path
        if fileManager.fileExists(atPath: originalPath) {
            return originalPath
        }
        
        // Get the filename component
        let filename = (originalPath as NSString).lastPathComponent
        
        // Strategy 2: Try in current working directory
        if let currentDirectory = ProcessInfo.processInfo.environment["PWD"] {
            let currentDirPath = (currentDirectory as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: currentDirPath) {
                return currentDirPath
            }
        }
        
        // Strategy 3: Try in the workspace folder if defined
        if let workspaceFolder = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] {
            let workspacePath = (workspaceFolder as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: workspacePath) {
                return workspacePath
            }
            
            // Strategy 4: Search 1 level deep in workspace folder
            if let items = try? fileManager.contentsOfDirectory(atPath: workspaceFolder) {
                for item in items {
                    let itemPath = (workspaceFolder as NSString).appendingPathComponent(item)
                    let isDirectory = (try? fileManager.attributesOfItem(atPath: itemPath)[.type] as? FileAttributeType) == .typeDirectory
                    
                    if isDirectory {
                        let potentialPath = (itemPath as NSString).appendingPathComponent(filename)
                        if fileManager.fileExists(atPath: potentialPath) {
                            return potentialPath
                        }
                    }
                }
            }
        }
        
        // Strategy 5: Try in current project directory if available
        if let projectPath = currentProject {
            let projectDir = (projectPath as NSString).deletingLastPathComponent
            let projectFilePath = (projectDir as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: projectFilePath) {
                return projectFilePath
            }
        }
        
        // If all strategies fail, return the original path
        return originalPath
    }
    
    public static func determineLanguage(from filePath: String) -> String {
        let fileExtension = (filePath as NSString).pathExtension.lowercased()
        
        switch fileExtension {
        case "swift":
            return "swift"
        case "m", "h":
            return "objc"
        case "c", "cpp", "cc":
            return "c"
        case "js":
            return "javascript"
        case "py":
            return "python"
        case "rb":
            return "ruby"
        case "java":
            return "java"
        case "html", "htm":
            return "html"
        case "css":
            return "css"
        case "json":
            return "json"
        case "xml":
            return "xml"
        default:
            return "text"
        }
    }
}
