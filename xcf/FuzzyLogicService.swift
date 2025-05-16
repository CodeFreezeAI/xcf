//
//  FuzzyLogicService.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

/// A service that provides fuzzy matching and file finding capabilities
struct FuzzyLogicService {
    // MARK: - Public Interface
    
    /// Attempts to find a file using multiple search strategies
    /// - Parameter originalPath: The original file path or name to search for
    /// - Returns: A tuple containing the resolved path and any warning messages
    static func findFile(_ originalPath: String) -> (path: String, warning: String) {
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
        
        // Strategy 4: Try in project manager's current folder
        if let currentFolder = XcfXcodeProjectManager.shared.currentFolder {
            let currentFolderPath = (currentFolder as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: currentFolderPath) {
                duplicates.append(currentFolderPath)
            }
            
            // Strategy 5: Search recursively in current folder (limited depth)
            searchRecursively(in: currentFolder, forFile: filename, maxDepth: 3, duplicates: &duplicates)
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
        
        // Strategy 7: Last resort - try a fuzzy search in all available directories
        if let bestMatch = findBestFuzzyMatch(for: filename) {
            return (bestMatch.path, "Warning: Couldn't find exact file '\(filename)'. Using similar file: '\((bestMatch.path as NSString).lastPathComponent)' (similarity: \(Int(bestMatch.score * 100))%)")
        }
        
        // If all strategies fail, return the original path
        return (originalPath, "")
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
        
        // Add current working directory
        if let pwd = ProcessInfo.processInfo.environment["PWD"] {
            directories.insert(pwd)
        }
        
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