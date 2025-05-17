import Foundation
import AppKit

/// A utility struct that provides file system operations with smart path resolution.
struct XcfFileManager {
    /// Reads the contents of a file
    /// - Parameter filePath: Path to the file to read
    /// - Returns: The contents of the file as a string
    /// - Throws: Error if file cannot be read
    static func readFile(at filePath: String) throws -> (String, String) {
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.fileNotFound, filePath)])
        }
        
        do {
            let content = try String(contentsOfFile: resolvedPath, encoding: .utf8)
            return (content, warning)
        } catch {
            throw error
        }
    }
    
    /// Writes content to a file
    /// - Parameters:
    ///   - content: The content to write
    ///   - path: The path of the file to write to
    /// - Throws: Error if file cannot be written
    static func writeFile(content: String, to path: String) throws {
        // Get the project directory first
        let projectDir = XcfXcodeProjectManager.shared.currentFolder ?? FileManager.default.currentDirectoryPath
        
        // Verify the project directory exists and is valid
        var isProjectDirDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: projectDir, isDirectory: &isProjectDirDirectory),
              isProjectDirDirectory.boolValue else {
            throw NSError(domain: "XcfFileManager",
                         code: 2,
                         userInfo: [NSLocalizedDescriptionKey: "Invalid project directory: \(projectDir)"])
        }
        
        // Determine the full path
        let fullPath: String
        if path.hasPrefix("/") || path.hasPrefix("~") {
            fullPath = (path as NSString).expandingTildeInPath
        } else {
            fullPath = (projectDir as NSString).appendingPathComponent(path)
        }
        
        // Create intermediate directories if needed
        let directory = (fullPath as NSString).deletingLastPathComponent
        if !FileManager.default.fileExists(atPath: directory) {
            try FileManager.default.createDirectory(atPath: directory,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
        }
        
        // Write the file
        try content.write(toFile: fullPath, atomically: true, encoding: .utf8)
    }
    
    /// Creates a new file with content
    /// - Parameters:
    ///   - filePath: Path where the file should be created
    ///   - content: Initial content for the file
    /// - Throws: Error if file cannot be created
    static func createFile(at filePath: String, content: String) throws {
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        if !warning.isEmpty {
            print(warning)
        }
        
        guard !FileManager.default.fileExists(atPath: resolvedPath) else {
            throw NSError(domain: "XcfFileManager", code: 2, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.fileAlreadyExists, filePath)])
        }
        
        // Create directory structure if needed
        let directory = (resolvedPath as NSString).deletingLastPathComponent
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        
        try content.write(toFile: resolvedPath, atomically: true, encoding: .utf8)
    }
    
    /// Edits a specific range of lines in a file
    /// - Parameters:
    ///   - filePath: Path to the file to edit
    ///   - startLine: First line to edit (1-indexed)
    ///   - endLine: Last line to edit (1-indexed)
    ///   - replacementContent: New content for the specified line range
    /// - Throws: Error if file cannot be edited
    static func editFile(at filePath: String, startLine: Int, endLine: Int, replacementContent: String) throws {
        // Security check with path resolution
        let (allowed, resolvedPath, error) = SecurityManager.shared.isFileOperationAllowed(filePath, operation: "edit")
        if !allowed {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: error ?? "Access denied"])
        }
        
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.fileNotFound, filePath)])
        }
        
        do {
            let content = try String(contentsOfFile: resolvedPath, encoding: .utf8)
            var lines = content.components(separatedBy: .newlines)
            
            guard startLine > 0, endLine <= lines.count, startLine <= endLine else {
                throw NSError(domain: "XcfFileManager", code: 3, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.invalidLineNumbers])
            }
            
            let replacementLines = replacementContent.components(separatedBy: .newlines)
            lines.replaceSubrange((startLine - 1)...(endLine - 1), with: replacementLines)
            
            let newContent = lines.joined(separator: "\n")
            try newContent.write(toFile: resolvedPath, atomically: true, encoding: .utf8)
        } catch {
            throw error
        }
    }
    
    /// Deletes a file
    /// - Parameter filePath: Path to the file to delete
    /// - Throws: Error if file cannot be deleted
    static func deleteFile(at filePath: String) throws {
        // Security check with path resolution
        let (allowed, resolvedPath, error) = SecurityManager.shared.isFileOperationAllowed(filePath, operation: "delete")
        if !allowed {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: error ?? "Access denied"])
        }
        
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.fileNotFound, filePath)])
        }
        
        try FileManager.default.removeItem(atPath: resolvedPath)
    }
    
    /// Creates a new directory
    /// - Parameter directoryPath: Path where the directory should be created
    /// - Throws: Error if directory cannot be created
    static func createDirectory(at directoryPath: String) throws {
        let (resolvedPath, warning) = FuzzyLogicService.resolveDirectoryPath(directoryPath)
        if !warning.isEmpty {
            print(warning)
        }
        
        guard !FileManager.default.fileExists(atPath: resolvedPath) else {
            throw NSError(domain: "XcfFileManager", code: 2, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.directoryAlreadyExists, directoryPath)])
        }
        
        try FileManager.default.createDirectory(atPath: resolvedPath, withIntermediateDirectories: true)
    }
    
    /// Removes a directory and its contents
    /// - Parameter directoryPath: Path to the directory to remove
    /// - Throws: Error if directory cannot be removed
    static func removeDirectory(at directoryPath: String) throws {
        // Security check with path resolution
        let (allowed, resolvedPath, error) = SecurityManager.shared.isDirectoryOperationAllowed(directoryPath, operation: "remove")
        if !allowed {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: error ?? "Access denied"])
        }
        
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.directoryNotFound, directoryPath)])
        }
        
        try FileManager.default.removeItem(atPath: resolvedPath)
    }
    
    /// Changes the current working directory
    /// - Parameter path: The path to change to
    /// - Throws: Error if directory cannot be changed
    static func changeDirectory(to path: String) throws {
        // Get the project directory first
        let projectDir = XcfXcodeProjectManager.shared.currentFolder ?? FileManager.default.currentDirectoryPath
        
        // Verify the project directory exists and is valid
        var isProjectDirDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: projectDir, isDirectory: &isProjectDirDirectory),
              isProjectDirDirectory.boolValue else {
            throw NSError(domain: "XcfFileManager",
                         code: 2,
                         userInfo: [NSLocalizedDescriptionKey: "Invalid project directory: \(projectDir)"])
        }
        
        // Now resolve the target path
        let (resolvedPath, warning) = FuzzyLogicService.resolveDirectoryPath(path)
        if !warning.isEmpty {
            print(warning)
        }
        
        // Verify the target directory exists
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: resolvedPath, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw NSError(domain: "XcfFileManager",
                         code: 2,
                         userInfo: [NSLocalizedDescriptionKey: "Directory not found: \(resolvedPath)"])
        }
        
        // Change the directory
        FileManager.default.changeCurrentDirectoryPath(resolvedPath)
        
        // Update the current folder in XcfXcodeProjectManager
        XcfXcodeProjectManager.shared.currentFolder = resolvedPath
    }
    
    /// Lists contents of a directory with optional file extension filter
    /// - Parameters:
    ///   - directoryPath: Path to the directory to list
    ///   - fileExtension: Optional file extension to filter by
    /// - Returns: Array of file paths in the directory
    /// - Throws: Error if directory cannot be read
    static func readDirectory(at directoryPath: String, fileExtension: String? = nil) throws -> [String] {
        // Get and verify the project directory
        guard let projectDir = XcfXcodeProjectManager.shared.currentFolder else {
            throw NSError(domain: "XcfFileManager",
                         code: 2,
                         userInfo: [NSLocalizedDescriptionKey: "No current project directory set"])
        }
        
        // For "." or empty path, use project directory directly
        let targetPath: String
        if directoryPath.isEmpty || directoryPath == "." {
            targetPath = projectDir
        } else if directoryPath.hasPrefix("/") {
            targetPath = directoryPath
        } else if directoryPath == ".." {
            targetPath = (projectDir as NSString).deletingLastPathComponent
        } else {
            targetPath = (projectDir as NSString).appendingPathComponent(directoryPath)
        }
        
        // Verify directory exists
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: targetPath, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw NSError(domain: "XcfFileManager",
                         code: 1,
                         userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.directoryNotFound, targetPath)])
        }
        
        // Get directory contents
        let contents = try FileManager.default.contentsOfDirectory(atPath: targetPath)
        
        // Apply extension filter if specified
        if let ext = fileExtension {
            return contents.filter { $0.hasSuffix("." + ext) }
                         .map { (targetPath as NSString).appendingPathComponent($0) }
        }
        
        return contents.map { (targetPath as NSString).appendingPathComponent($0) }
    }
    
    /// Shows a directory selection dialog and returns the selected path
    /// - Returns: The selected directory path, or nil if cancelled
    static func selectDirectory() -> String? {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select a directory"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == .OK {
            return dialog.url?.path
        } else {
            return nil
        }
    }

    /// Creates a new Swift document with FileManager
    /// - Parameters:
    ///   - filePath: The path where the Swift file should be created
    ///   - content: Initial content of the Swift file (optional)
    /// - Returns: True if successful, false otherwise
    static func createSwiftDocument(filePath: String, content: String = "") throws {
        // Ensure the file path ends with .swift
        let path = filePath.hasSuffix(".swift") ? filePath : filePath + ".swift"
        
        // Check if file already exists
        if FileManager.default.fileExists(atPath: path) {
            throw NSError(domain: "XcfFileManager", code: 4, userInfo: [NSLocalizedDescriptionKey: "File already exists at: \(path)"])
        }
        
        // Create the directory structure if it doesn't exist
        let directory = (path as NSString).deletingLastPathComponent
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)
        
        // Write the content to the new file
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }

    /// Edits a Swift document by replacing text at specified range using FileManager
    /// - Parameters:
    ///   - filePath: The path to the Swift file to edit
    ///   - startLine: The starting line to replace (1-indexed)
    ///   - endLine: The ending line to replace (1-indexed)
    ///   - replacement: The replacement text
    /// - Returns: The edited content and any warnings
    /// - Throws: File operation errors
    static func editSwiftDocument(filePath: String, startLine: Int, endLine: Int, replacement: String) throws -> (String, String) {
        let (content, warning) = try readFile(at: filePath)
        let lines = content.components(separatedBy: .newlines)
        
        // Validate line numbers
        guard startLine > 0, endLine > 0, startLine <= lines.count, endLine <= lines.count, startLine <= endLine else {
            throw NSError(domain: "XcfFileManager", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid line numbers. File has \(lines.count) lines."])
        }
        
        // Create new content with replacement
        var newLines = lines
        
        // Remove the lines to be replaced
        newLines.removeSubrange(startLine - 1...endLine - 1)
        
        // Insert the replacement text at the start line
        let replacementLines = replacement.components(separatedBy: .newlines)
        newLines.insert(contentsOf: replacementLines, at: startLine - 1)
        
        // Join the lines back together
        let newContent = newLines.joined(separator: "\n")
        
        // Write the modified content back to the file
        try writeFile(content: newContent, to: filePath)
        
        return (newContent, warning)
    }

    /// Moves a file from one location to another
    /// - Parameters:
    ///   - sourcePath: Path of the file to move
    ///   - destinationPath: Path where the file should be moved to
    /// - Throws: Error if file cannot be moved
    static func moveFile(from sourcePath: String, to destinationPath: String) throws {
        // Security check with path resolution for source file
        let (sourceAllowed, resolvedSourcePath, sourceError) = SecurityManager.shared.isFileOperationAllowed(sourcePath, operation: "move")
        if !sourceAllowed {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: sourceError ?? "Access denied for source file"])
        }
        
        // Security check with path resolution for destination
        let (destAllowed, resolvedDestPath, destError) = SecurityManager.shared.isFileOperationAllowed(destinationPath, operation: "move")
        if !destAllowed {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: destError ?? "Access denied for destination path"])
        }
        
        // Check if source file exists
        guard FileManager.default.fileExists(atPath: resolvedSourcePath) else {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: String(format: ErrorMessages.fileNotFound, sourcePath)])
        }
        
        // Create destination directory if it doesn't exist
        let destinationDir = (resolvedDestPath as NSString).deletingLastPathComponent
        if !FileManager.default.fileExists(atPath: destinationDir) {
            try FileManager.default.createDirectory(atPath: destinationDir, withIntermediateDirectories: true)
        }
        
        // Move the file
        try FileManager.default.moveItem(atPath: resolvedSourcePath, toPath: resolvedDestPath)
    }
} 