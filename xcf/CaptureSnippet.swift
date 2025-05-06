//
//  CodeSnippets.swift
//  xcf
//
//  Created by Todd Bruss on 5/6/25.
//

import Foundation

func captureSnippet(from filePath: String, startLine: Int, endLine: Int) -> String {
    do {
        // Read the content of the file into a single string
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)

        // Split the content into lines
        let lines = fileContent.components(separatedBy: .newlines)

        // Validate line numbers
        guard startLine > 0, endLine >= startLine, endLine <= lines.count else {
            return("Code Snippet Error: Invalid line numbers.")
        }

        // Extract the lines within the specified range
        let snippetLines = lines[(startLine - 1)...(endLine - 1)]

        // Join the lines back into a single string
        return snippetLines.joined(separator: "\n")

    } catch {
        return("Code Snippet want to Error reading file: \(error.localizedDescription)")
    }
}
