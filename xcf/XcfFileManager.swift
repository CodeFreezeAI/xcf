import Foundation
import AppKit

/// A struct responsible for handling all file system operations.
struct XcfFileManager {
    /// Read contents of a directory with optional file extension filter
    /// - Parameters:
    ///   - directoryPath: Path to the directory to read
    ///   - fileExtension: Optional file extension to filter by
    /// - Returns: Array of file paths
    /// - Throws: FileManager errors
    static func readDirectory(at directoryPath: String, fileExtension: String? = nil) throws -> [String] {
        let filePaths = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
        if let ext = fileExtension {
            return filePaths.filter { $0.hasSuffix(".\(ext)") }
        }
        return filePaths
    }
    
    /// Create a directory at the specified path
    /// - Parameter directoryPath: Path where to create the directory
    /// - Throws: FileManager errors
    static func createDirectory(at directoryPath: String) throws {
        try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Delete a file at the specified path
    /// - Parameter filePath: Path to the file to delete
    /// - Throws: FileManager errors
    static func deleteFile(at filePath: String) throws {
        try FileManager.default.removeItem(atPath: filePath)
    }
    
    /// Write content to a file
    /// - Parameters:
    ///   - content: Content to write
    ///   - filePath: Path where to write the file
    /// - Throws: File writing errors
    static func writeFile(content: String, to filePath: String) throws {
        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    /// Create a new file with content
    /// - Parameters:
    ///   - filePath: Path where to create the file
    ///   - content: Content to write to the file
    /// - Throws: File creation errors
    static func createFile(at filePath: String, content: String) throws {
        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    /// Read contents of a file
    /// - Parameter filePath: Path to the file to read
    /// - Returns: File contents as string
    /// - Throws: File reading errors
    static func readFile(at filePath: String) throws -> String {
        // Validate file exists
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            throw NSError(domain: "XcfFileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "File does not exist: \(filePath)"])
        }
        
        // Check file size
        guard let attributes = try? fileManager.attributesOfItem(atPath: filePath),
              let fileSize = attributes[FileAttributeKey.size] as? UInt64 else {
            throw NSError(domain: "XcfFileManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not determine file size: \(filePath)"])
        }
        
        // Set a reasonable size limit (10MB)
        let sizeLimit: UInt64 = 10 * 1024 * 1024
        guard fileSize < sizeLimit else {
            throw NSError(domain: "XcfFileManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "File is too large (> 10MB): \(filePath)"])
        }
        
        return try String(contentsOfFile: filePath, encoding: .utf8)
    }

    /// Lists files and directories at the specified path
    /// - Parameters:
    ///   - directoryPath: The path to list contents from
    ///   - extension: Optional file extension filter (e.g., "swift")
    /// - Returns: Array of file/directory paths, or empty array if operation failed
    static func listDirectory(at directoryPath: String, extension fileExtension: String? = nil) throws -> [String] {
        let contents = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
        
        if let ext = fileExtension {
            return contents.filter { $0.hasSuffix(".\(ext)") }
                .map { directoryPath + "/" + $0 }
        } else {
            return contents.map { directoryPath + "/" + $0 }
        }
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
    /// - Returns: The edited content
    /// - Throws: File operation errors
    static func editSwiftDocument(filePath: String, startLine: Int, endLine: Int, replacement: String) throws -> String {
        let content = try readFile(at: filePath)
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
        
        return newContent
    }
} 