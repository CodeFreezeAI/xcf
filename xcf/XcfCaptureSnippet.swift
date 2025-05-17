//
//  CodeSnippets.swift
//  xcf
//
//  Created by Todd Bruss on 5/6/25.
//

import Foundation

/// A utility struct that provides functionality for capturing code snippets from files.
/// This struct offers methods to extract specific line ranges from source code files
/// and determine the programming language based on file extensions.
struct CaptureSnippet {
    /// Extracts a code snippet from a file at the specified line range.
    ///
    /// This function attempts to locate the file using FuzzyLogicService,
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
        
        // Try to find the file using FuzzyLogicService
        let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
        
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
