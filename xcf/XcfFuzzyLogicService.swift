//
//  XcfFuzzyLogicService.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

/// A service that provides fuzzy matching and file finding capabilities
struct FuzzyLogicService {
    // MARK: - Public Interface
    
    /// Resolves any path (file or directory) using consistent rules
    /// - Parameter path: The path to resolve
    /// - Returns: A tuple containing the resolved path and any warning messages
    static func resolvePath(_ path: String, isDirectory: Bool = false) -> (path: String, warning: String) {
        // Get and verify the project directory
        guard let projectDir = XcfXcodeProjectManager.shared.currentFolder else {
            return (path, "No current project directory set")
        }
        
        // For "." or empty path, use project directory directly
        if path.isEmpty || path == "." {
            return (projectDir, "")
        }
        
        // For absolute paths
        if path.hasPrefix("/") || path.hasPrefix("~") {
            let expandedPath = (path as NSString).expandingTildeInPath
            var isDir: ObjCBool = ObjCBool(isDirectory)
            if FileManager.default.fileExists(atPath: expandedPath, isDirectory: &isDir) {
                if isDirectory == isDir.boolValue {
                    return (expandedPath, "")
                }
            }
            // Even if file doesn't exist, return the expanded path for creation
            return (expandedPath, "")
        }
        
        // For ".." path
        if path == ".." {
            return ((projectDir as NSString).deletingLastPathComponent, "")
        }
        
        // For relative paths
        let fullPath = (projectDir as NSString).appendingPathComponent(path)
        var isDir: ObjCBool = ObjCBool(isDirectory)
        if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
            if isDirectory == isDir.boolValue {
                return (fullPath, "")
            }
        }
        
        // If file/directory doesn't exist, return the full path for creation
        return (fullPath, "")
    }
    
    /// Resolves a file path using consistent rules
    /// - Parameter filePath: The file path to resolve
    /// - Returns: A tuple containing the resolved path and any warning messages
    static func resolveFilePath(_ filePath: String) -> (path: String, warning: String) {
        return resolvePath(filePath, isDirectory: false)
    }
    
    /// Resolves a directory path using consistent rules
    /// - Parameter dirPath: The directory path to resolve
    /// - Returns: A tuple containing the resolved path and any warning messages
    static func resolveDirectoryPath(_ dirPath: String) -> (path: String, warning: String) {
        return resolvePath(dirPath, isDirectory: true)
    }
    
    // MARK: - Private Methods
    
    /// Search recursively in a directory for a file
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
    
    /// Find the best fuzzy match for a filename across all available directories
    private static func findBestFuzzyMatch(for filename: String) -> (path: String, score: Double)? {
        var bestMatch: (path: String, score: Double)? = nil
        let directories = getSearchDirectories()
        
        for directory in directories {
            if let match = searchDirectoryForFuzzyMatch(filename, in: directory) {
                if bestMatch == nil || match.score > bestMatch!.score {
                    bestMatch = match
                }
            }
        }
        
        // Only return matches above 70% similarity
        return bestMatch?.score ?? 0 > 0.7 ? bestMatch : nil
    }
    
    /// Get all directories to search in
    private static func getSearchDirectories() -> Set<String> {
        var directories = Set<String>()
        
        // Add current folder from project manager
        if let currentFolder = XcfXcodeProjectManager.shared.currentFolder {
            directories.insert(currentFolder)
        }
        
        // Add project directory
        if let projectPath = XcfXcodeProjectManager.shared.currentProject {
            let projectDir = (projectPath as NSString).deletingLastPathComponent
            directories.insert(projectDir)
            // Also add parent directory
            directories.insert((projectDir as NSString).deletingLastPathComponent)
        }
        
        return directories
    }
    
    /// Search a directory for fuzzy matches
    private static func searchDirectoryForFuzzyMatch(_ filename: String, in directory: String) -> (path: String, score: Double)? {
        var bestMatch: (path: String, score: Double)? = nil
        
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
                    if bestMatch == nil || similarity > bestMatch!.score {
                        bestMatch = (itemPath, similarity)
                    }
                } else if currentDepth < maxDepth {
                    // Recurse into subdirectories
                    searchDirectory(itemPath, maxDepth: maxDepth, currentDepth: currentDepth + 1)
                }
            }
        }
        
        searchDirectory(directory)
        return bestMatch
    }
    
    /// Calculate string similarity using Levenshtein distance
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
} 
