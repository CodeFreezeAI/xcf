//
//  SecurityManager.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation

/// Manages security checks for file operations
class SecurityManager {
    // Singleton instance
    static let shared = SecurityManager()
    
    private init() {}
    
    /// The user's home directory
    private var homeDirectory: String {
        return FileManager.default.homeDirectoryForCurrentUser.path
    }
    
    /// The current working directory
    private var currentWorkingDirectory: String {
        return FileManager.default.currentDirectoryPath
    }
    
    /// Check if a path is within the user's home directory or current working directory
    /// - Parameter path: The path to check
    /// - Returns: A tuple containing (isAllowed, resolvedPath, errorMessage)
    func isPathAllowed(_ path: String) -> (allowed: Bool, resolvedPath: String, error: String?) {
        // First try to resolve the path using FileFinder for fuzzy matching
        let (resolvedPath, _) = FileFinder.resolveFilePath(path)
        let standardizedPath = (resolvedPath as NSString).standardizingPath
        
        // Always allow access to home directory itself
        if standardizedPath == homeDirectory {
            return (true, standardizedPath, nil)
        }
        
        // Check if path is within home directory
        if standardizedPath.hasPrefix(homeDirectory) {
            return (true, standardizedPath, nil)
        }
        
        // Check if it's a relative path or in current working directory
        let currentDir = currentWorkingDirectory
        if currentDir.hasPrefix(homeDirectory) {
            // If the current directory is within home directory, try relative path resolution
            let relativePath = (currentDir as NSString).appendingPathComponent(path)
            let standardizedRelativePath = (relativePath as NSString).standardizingPath
            
            if standardizedRelativePath.hasPrefix(homeDirectory) {
                return (true, standardizedRelativePath, nil)
            }
            
            // Try fuzzy matching within current directory
            if let fuzzyMatch = findFuzzyMatch(for: path, in: currentDir) {
                let standardizedFuzzyPath = (fuzzyMatch as NSString).standardizingPath
                if standardizedFuzzyPath.hasPrefix(homeDirectory) {
                    return (true, standardizedFuzzyPath, nil)
                }
            }
        }
        
        return (false, standardizedPath, "Security Error: Access denied. Operations are restricted to your home directory (\(homeDirectory))")
    }
    
    /// Find a fuzzy match for a path in the specified directory
    /// - Parameters:
    ///   - path: The path to find a match for
    ///   - directory: The directory to search in
    /// - Returns: The matched path if found, nil otherwise
    private func findFuzzyMatch(for path: String, in directory: String) -> String? {
        let fileManager = FileManager.default
        guard let contents = try? fileManager.contentsOfDirectory(atPath: directory) else {
            return nil
        }
        
        // Clean up the path by trimming whitespace and normalizing separators
        let cleanPath = path.trimmingCharacters(in: .whitespaces)
                           .replacingOccurrences(of: "\\", with: "/")
        let searchPath = (cleanPath as NSString).lastPathComponent
        
        // First try exact match (case-sensitive)
        if contents.contains(searchPath) {
            return (directory as NSString).appendingPathComponent(searchPath)
        }
        
        // Try case-insensitive exact match
        let lowercasePath = searchPath.lowercased()
        if let match = contents.first(where: { $0.lowercased() == lowercasePath }) {
            return (directory as NSString).appendingPathComponent(match)
        }
        
        // Try prefix match (case-insensitive)
        if let match = contents.first(where: { $0.lowercased().hasPrefix(lowercasePath) }) {
            return (directory as NSString).appendingPathComponent(match)
        }
        
        // Try contains match (case-insensitive)
        if let match = contents.first(where: { $0.lowercased().contains(lowercasePath) }) {
            return (directory as NSString).appendingPathComponent(match)
        }
        
        // Try matching by removing common file extensions
        let pathWithoutExt = (searchPath as NSString).deletingPathExtension.lowercased()
        if let match = contents.first(where: { 
            let itemWithoutExt = ($0 as NSString).deletingPathExtension.lowercased()
            return itemWithoutExt == pathWithoutExt || 
                   itemWithoutExt.hasPrefix(pathWithoutExt) || 
                   itemWithoutExt.contains(pathWithoutExt)
        }) {
            return (directory as NSString).appendingPathComponent(match)
        }
        
        // Try Levenshtein distance for close matches
        let threshold = min(3, searchPath.count / 3) // Allow 1 error per 3 characters, max 3
        if threshold > 0 {
            var bestMatch: String? = nil
            var bestDistance = Int.max
            
            for item in contents {
                let itemWithoutExt = (item as NSString).deletingPathExtension.lowercased()
                let searchWithoutExt = pathWithoutExt
                
                let distance = levenshteinDistance(itemWithoutExt, searchWithoutExt)
                if distance < bestDistance && distance <= threshold {
                    bestDistance = distance
                    bestMatch = item
                }
            }
            
            if let match = bestMatch {
                return (directory as NSString).appendingPathComponent(match)
            }
        }
        
        return nil
    }
    
    /// Calculate Levenshtein distance between two strings
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        let m = s1Array.count
        let n = s2Array.count
        
        var matrix = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        // Initialize first row and column
        for i in 0...m {
            matrix[i][0] = i
        }
        for j in 0...n {
            matrix[0][j] = j
        }
        
        // Fill in the rest of the matrix
        for i in 1...m {
            for j in 1...n {
                if s1Array[i-1] == s2Array[j-1] {
                    matrix[i][j] = matrix[i-1][j-1]
                } else {
                    matrix[i][j] = min(
                        matrix[i-1][j] + 1,    // deletion
                        matrix[i][j-1] + 1,    // insertion
                        matrix[i-1][j-1] + 1   // substitution
                    )
                }
            }
        }
        
        return matrix[m][n]
    }
    
    /// Check if a directory operation is allowed
    /// - Parameters:
    ///   - path: The directory path to check
    ///   - operation: The operation being performed (for error messages)
    /// - Returns: A tuple containing (isAllowed, resolvedPath, errorMessage)
    func isDirectoryOperationAllowed(_ path: String, operation: String) -> (allowed: Bool, resolvedPath: String, error: String?) {
        return isPathAllowed(path)
    }
    
    /// Check if a file operation is allowed
    /// - Parameters:
    ///   - path: The file path to check
    ///   - operation: The operation being performed (for error messages)
    /// - Returns: A tuple containing (isAllowed, resolvedPath, errorMessage)
    func isFileOperationAllowed(_ path: String, operation: String) -> (allowed: Bool, resolvedPath: String, error: String?) {
        return isPathAllowed(path)
    }
    
    /// Resolve and validate a path for security
    /// - Parameter path: The path to resolve and validate
    /// - Returns: A tuple containing (resolvedPath, errorMessage)
    func resolveAndValidatePath(_ path: String) -> (resolvedPath: String?, error: String?) {
        // First use FileFinder to resolve the path
        let (resolvedPath, _) = FileFinder.resolveFilePath(path)
        
        // Then check if the resolved path is allowed
        let (allowed, resolvedPath2, error) = isPathAllowed(resolvedPath)
        if !allowed {
            return (nil, error)
        }
        
        return (resolvedPath2, nil)
    }
} 