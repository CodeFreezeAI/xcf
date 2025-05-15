//
//  FileFinder.swift
//  xcf
//
//  Created by Todd Bruss on 5/9/25.
//

import Foundation

/// A utility class to find files in the workspace using multiple strategies.
struct FileFinder {
    /// Attempts to intelligently resolve a file path using multiple strategies
    /// - Parameter originalPath: The original path provided
    /// - Returns: A tuple containing (resolvedPath, warningMessage) where resolvedPath is the resolved path or original if no strategies succeed, and warningMessage contains any warnings about duplicate files
    static func resolveFilePath(_ originalPath: String) -> (String, String) {
        let fileManager = FileManager.default
        var duplicates: [String] = []
        
        // Strategy 1: Try the original path
        if fileManager.fileExists(atPath: originalPath) {
            return (originalPath, "")
        }
        
        // Get the filename component and check if it's a relative path
        let isRelativePath = !(originalPath.hasPrefix("/") || originalPath.hasPrefix("~"))
        let filename = (originalPath as NSString).lastPathComponent
        
        // Strategy 2: If it's a relative path and we have currentFolder, try to resolve it
        if isRelativePath, let cf = XcfXcodeProjectManager.shared.currentFolder {
            // Handle paths that might start with ./ or ../
            var relativePath = originalPath
            if relativePath.hasPrefix("./") {
                relativePath = String(relativePath.dropFirst(2))
            }
            
            let fullPath = (cf as NSString).appendingPathComponent(relativePath)
            if fileManager.fileExists(atPath: fullPath) {
                return (fullPath, "")
            }
        }
        
        // Strategy 3: Try in current working directory
        if let currentDirectory = ProcessInfo.processInfo.environment["PWD"] {
            let currentDirPath = (currentDirectory as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: currentDirPath) {
                duplicates.append(currentDirPath)
            }
        }
        
        // Strategy 4: Try in the workspace folder if defined
        if let workspaceFolder = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] {
            let workspacePath = (workspaceFolder as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: workspacePath) {
                duplicates.append(workspacePath)
            }
            
            // Strategy 5: Search recursively in workspace folder (limited depth)
            searchRecursively(in: workspaceFolder, forFile: filename, maxDepth: 3, duplicates: &duplicates)
        }
        
        // Strategy 6: Try in current project directory if available
        if let projectPath = XcfXcodeProjectManager.shared.currentProject {
            let projectDir = (projectPath as NSString).deletingLastPathComponent
            let projectFilePath = (projectDir as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: projectFilePath) {
                duplicates.append(projectFilePath)
            }
            
            // Also try one level up from project directory (common for source folders)
            let projectParentDir = (projectDir as NSString).deletingLastPathComponent
            let parentFilePath = (projectParentDir as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: parentFilePath) {
                duplicates.append(parentFilePath)
            }
        }
        
        // If we found exactly one file, return it
        if duplicates.count == 1 {
            return (duplicates[0], "")
        }
        
        // If we found multiple files, return the first one with a warning
        if duplicates.count > 1 {
            let warning = "Warning: Found multiple files matching '\(filename)':\n" + 
                          duplicates.enumerated().map { "[\($0.0 + 1)] \($0.1)" }.joined(separator: "\n") +
                          "\nUsing the first match."
            return (duplicates[0], warning)
        }
        
        // Strategy 7: Last resort - try a fuzzy search for similar filenames in workspace
        if let workspaceFolder = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] {
            let (fuzzyMatch, similarityScore) = findSimilarFilename(filename, in: workspaceFolder)
            if let fuzzyMatch = fuzzyMatch, similarityScore > 0.7 { // Threshold for similarity
                return (fuzzyMatch, "Warning: Couldn't find exact file '\(filename)'. Using similar file: '\((fuzzyMatch as NSString).lastPathComponent)'")
            }
        }
        
        // If all strategies fail, return the original path
        return (originalPath, "")
    }
    
    /// Search recursively in a directory for a file with the given name
    /// - Parameters:
    ///   - directory: The directory to search in
    ///   - filename: The filename to search for
    ///   - currentDepth: The current depth of recursion
    ///   - maxDepth: The maximum depth to search
    ///   - duplicates: Array to collect duplicate files found
    private static func searchRecursively(in directory: String, forFile filename: String, currentDepth: Int = 0, maxDepth: Int, duplicates: inout [String]) {
        guard currentDepth <= maxDepth else { return }
        
        let fileManager = FileManager.default
        guard let items = try? fileManager.contentsOfDirectory(atPath: directory) else { return }
        
        for item in items {
            let itemPath = (directory as NSString).appendingPathComponent(item)
            
            // Check if this is the file we're looking for
            if item == filename && fileManager.fileExists(atPath: itemPath) {
                duplicates.append(itemPath)
            }
            
            // If it's a directory, search recursively
            let isDirectory = (try? fileManager.attributesOfItem(atPath: itemPath)[.type] as? FileAttributeType) == .typeDirectory
            if isDirectory {
                searchRecursively(in: itemPath, forFile: filename, currentDepth: currentDepth + 1, maxDepth: maxDepth, duplicates: &duplicates)
            }
        }
    }
    
    /// Find a file with a similar name to the given filename in the directory
    /// - Parameters:
    ///   - filename: The filename to find similar matches for
    ///   - directory: The directory to search in
    /// - Returns: A tuple containing the path to the most similar file and its similarity score (0-1)
    private static func findSimilarFilename(_ filename: String, in directory: String) -> (String?, Double) {
        var bestMatch: String? = nil
        var bestScore = 0.0
        
        func searchDirectory(_ dir: String, maxDepth: Int = 2, currentDepth: Int = 0) {
            guard currentDepth <= maxDepth else { return }
            
            let fileManager = FileManager.default
            guard let items = try? fileManager.contentsOfDirectory(atPath: dir) else { return }
            
            for item in items {
                let itemPath = (dir as NSString).appendingPathComponent(item)
                
                // Check similarity for files
                let isDirectory = (try? fileManager.attributesOfItem(atPath: itemPath)[.type] as? FileAttributeType) == .typeDirectory
                if !isDirectory {
                    let similarity = calculateStringSimilarity(filename, item)
                    if similarity > bestScore {
                        bestScore = similarity
                        bestMatch = itemPath
                    }
                } else if currentDepth < maxDepth {
                    // Recurse into subdirectories, but limit depth
                    searchDirectory(itemPath, maxDepth: maxDepth, currentDepth: currentDepth + 1)
                }
            }
        }
        
        searchDirectory(directory)
        return (bestMatch, bestScore)
    }
    
    /// Calculate string similarity using Levenshtein distance
    /// - Parameters:
    ///   - a: First string
    ///   - b: Second string
    /// - Returns: Similarity score between 0 and 1, where 1 is exact match
    private static func calculateStringSimilarity(_ a: String, _ b: String) -> Double {
        let a = Array(a.lowercased())
        let b = Array(b.lowercased())
        
        let len_a = a.count
        let len_b = b.count
        
        // Special cases
        if len_a == 0 { return len_b == 0 ? 1.0 : 0.0 }
        if len_b == 0 { return 0.0 }
        
        // Initialize the distance matrix
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: len_b + 1), count: len_a + 1)
        
        // Set the first row and column
        for i in 0...len_a {
            matrix[i][0] = i
        }
        for j in 0...len_b {
            matrix[0][j] = j
        }
        
        // Fill the matrix
        for i in 1...len_a {
            for j in 1...len_b {
                let cost = a[i-1] == b[j-1] ? 0 : 1
                matrix[i][j] = min(
                    matrix[i-1][j] + 1,      // deletion
                    matrix[i][j-1] + 1,      // insertion
                    matrix[i-1][j-1] + cost  // substitution
                )
            }
        }
        
        // Calculate normalized similarity (1 - normalized distance)
        let maxLen = max(len_a, len_b)
        let distance = Double(matrix[len_a][len_b])
        return 1.0 - (distance / Double(maxLen))
    }
    
    /// Determines the language of a file based on its extension
    /// - Parameter filePath: The path to the file
    /// - Returns: A string indicating the language of the file
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