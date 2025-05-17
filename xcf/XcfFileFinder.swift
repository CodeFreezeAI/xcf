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
        return FuzzyLogicService.resolveFilePath(originalPath)
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