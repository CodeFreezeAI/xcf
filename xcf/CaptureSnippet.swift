//
//  CodeSnippets.swift
//  xcf
//
//  Created by Todd Bruss on 5/6/25.
//

import Foundation

/// A utility struct that provides functionality for capturing code snippets from files.
/// This struct offers methods to extract specific line ranges from source code files,
/// resolve file paths through various strategies, and determine the programming language
/// based on file extensions.
struct CaptureSnippet {
    /// Extracts a code snippet from a file at the specified line range.
    ///
    /// This function attempts to locate the file using multiple resolution strategies,
    /// then extracts either the specified line range or the entire file content.
    /// It also determines the programming language based on the file extension.
    ///
    /// - Parameters:
    ///   - filePath: The path to the source code file
    ///   - startLine: The first line to include in the snippet (1-indexed)
    ///   - endLine: The last line to include in the snippet (1-indexed)
    ///   - entireFile: If true, returns the entire file content regardless of line numbers
    /// - Returns: A tuple containing (snippet text with any warnings, detected language)
    static func getCodeSnippet(filePath: String, startLine: Int, endLine: Int, entireFile: Bool = false) -> (String, String) {
        var snippet = ""
        let language = FileFinder.determineLanguage(from: filePath)
        
        // Try to find the file using multiple strategies
        let (resolvedPath, warning) = FileFinder.resolveFilePath(filePath)
        
        // If we got a warning about duplicate files, prepend it to the snippet
        var warningMessage = ""
        if !warning.isEmpty {
            warningMessage = warning + Format.newLine + Format.newLine
        }
        
        do {
            let fileContents = try String(contentsOfFile: resolvedPath, encoding: .utf8)
            
            if entireFile {
                // If entireFile is true, return the whole file content regardless of line numbers
                return (warningMessage + fileContents, language)
            }
            
            let lines = fileContents.components(separatedBy: Format.newlinesCharSet())
            
            // Validate line numbers
            if startLine < 1 || endLine > lines.count || endLine < startLine {
                return (warningMessage + ErrorMessages.invalidLineNumbers, language)
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
        
        return (warningMessage + snippet, language)
    }
    
    /// Attempts to intelligently resolve a file path using multiple strategies.
    ///
    /// This method employs a series of progressive strategies to locate a file:
    /// 1. First tries the exact path as provided
    /// 2. Resolves relative paths using the current working directory
    /// 3. Searches in the current project directory
    /// 4. Searches recursively in the workspace, with limited depth
    /// 5. As a last resort, performs a fuzzy search for similar filenames
    ///
    /// If multiple matching files are found, returns the first match with a warning.
    ///
    /// - Parameter originalPath: The original file path provided by the user
    /// - Returns: A tuple containing (resolvedPath, warningMessage) where:
    ///   - resolvedPath: The successfully resolved path, or the original if no match found
    ///   - warningMessage: Any warnings about duplicate files or similar matches found
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
        if isRelativePath, let cf = currentFolder {
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
        if let projectPath = currentProject {
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
    
    /// Recursively searches a directory structure for files matching the target filename.
    ///
    /// This method traverses the directory tree up to a specified maximum depth,
    /// collecting all occurrences of the target filename along the way. It uses
    /// a depth-first search approach and guards against excessive recursion with
    /// the maxDepth parameter.
    /// 
    /// - Parameters:
    ///   - directory: The root directory to begin the search
    ///   - filename: The target filename to search for (without path)
    ///   - currentDepth: The current recursive depth (used internally, defaults to 0)
    ///   - maxDepth: The maximum depth to recurse into the directory tree
    ///   - duplicates: An array that collects all matching file paths found
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
    
    /// Finds the file with the most similar name to the target filename in a directory.
    ///
    /// When an exact filename match cannot be found, this method attempts to locate files
    /// with similar names using string similarity algorithms (Levenshtein distance). This
    /// provides a "fuzzy matching" capability that can help recover from minor typos or
    /// naming differences in file references.
    ///
    /// - Parameters:
    ///   - filename: The target filename to find similar matches for
    ///   - directory: The directory to search in (including subdirectories)
    /// - Returns: A tuple containing:
    ///   - The path to the most similar filename found (or nil if no suitable match)
    ///   - The similarity score (0.0-1.0) where 1.0 represents an exact match
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
    
    /// Calculates the similarity between two strings using the Levenshtein distance algorithm.
    ///
    /// The Levenshtein distance measures the minimum number of single-character edits
    /// (insertions, deletions, or substitutions) required to change one string into another.
    /// This implementation normalizes the result to a similarity score between 0.0 and 1.0,
    /// where 1.0 represents identical strings and 0.0 represents completely different strings.
    ///
    /// - Parameters:
    ///   - a: The first string to compare
    ///   - b: The second string to compare
    /// - Returns: A normalized similarity score between 0.0 and 1.0
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
    
    /// Determines the programming language based on the file extension
    /// 
    /// This function examines the file extension and maps it to a language
    /// identifier string that can be used for syntax highlighting or other
    /// language-specific processing.
    ///
    /// - Parameter filePath: The path to the file
    /// - Returns: A string identifier for the detected programming language
    public static func determineLanguage(from filePath: String) -> String {
        return FileFinder.determineLanguage(from: filePath)
    }
}
