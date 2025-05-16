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
    
    /// Check if a path is within the user's home directory
    /// - Parameter path: The path to check
    /// - Returns: A tuple containing (isAllowed, errorMessage)
    func isPathAllowed(_ path: String) -> (allowed: Bool, error: String?) {
        let resolvedPath = (path as NSString).standardizingPath
        
        // Always allow access to home directory itself
        if resolvedPath == homeDirectory {
            return (true, nil)
        }
        
        // Check if path is within home directory
        if resolvedPath.hasPrefix(homeDirectory) {
            return (true, nil)
        }
        
        return (false, "Security Error: Access denied. Operations are restricted to your home directory (\(homeDirectory))")
    }
    
    /// Check if a directory operation is allowed
    /// - Parameters:
    ///   - path: The directory path to check
    ///   - operation: The operation being performed (for error messages)
    /// - Returns: A tuple containing (isAllowed, errorMessage)
    func isDirectoryOperationAllowed(_ path: String, operation: String) -> (allowed: Bool, error: String?) {
        let (allowed, error) = isPathAllowed(path)
        if !allowed {
            return (false, error)
        }
        
        // Additional checks specific to directory operations can be added here
        
        return (true, nil)
    }
    
    /// Check if a file operation is allowed
    /// - Parameters:
    ///   - path: The file path to check
    ///   - operation: The operation being performed (for error messages)
    /// - Returns: A tuple containing (isAllowed, errorMessage)
    func isFileOperationAllowed(_ path: String, operation: String) -> (allowed: Bool, error: String?) {
        let (allowed, error) = isPathAllowed(path)
        if !allowed {
            return (false, error)
        }
        
        // Additional checks specific to file operations can be added here
        
        return (true, nil)
    }
    
    /// Resolve and validate a path for security
    /// - Parameter path: The path to resolve and validate
    /// - Returns: A tuple containing (resolvedPath, errorMessage)
    func resolveAndValidatePath(_ path: String) -> (resolvedPath: String?, error: String?) {
        // First use FileFinder to resolve the path
        let (resolvedPath, _) = FileFinder.resolveFilePath(path)
        
        // Then check if the resolved path is allowed
        let (allowed, error) = isPathAllowed(resolvedPath)
        if !allowed {
            return (nil, error)
        }
        
        return (resolvedPath, nil)
    }
} 