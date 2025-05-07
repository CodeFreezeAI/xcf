//
//  CodeSnippets.swift
//  xcf
//
//  Created by Todd Bruss on 5/6/25.
//

import Foundation

struct CaptureSnippet {
    static func getCodeSnippet(filePath: String, startLine: Int, endLine: Int, entireFile: Bool = false) -> (String, String) {
        var snippet = ""
        let language = determineLanguage(from: filePath)
        
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            
            if entireFile {
                // If entireFile is true, return the whole file content regardless of line numbers
                return (fileContents, language)
            }
            
            let lines = fileContents.components(separatedBy: Format.newlinesCharSet())
            
            // Validate line numbers
            if startLine < 1 || endLine > lines.count || endLine < startLine {
                return (ErrorMessages.invalidLineNumbers, language)
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
        
        return (snippet, language)
    }
    
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
