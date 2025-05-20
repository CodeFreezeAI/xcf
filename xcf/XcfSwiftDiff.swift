//
//  XcfSwiftDiff.swift
//  xcf
//
//  Created by Todd Bruss on 5/19/25.
//

import Foundation
import SwiftDiff


func createDiff(original: String, modified: String) -> [DiffOperation] {
    SwiftPatch.diff(original: original, modified: modified)
}

func applyDiff(original: String, operations: [DiffOperation]) throws -> String {
    try SwiftPatch.apply(original, operations: operations)
}

/// Creates a diff by comparing a source string with modified content
/// - Parameters:
///   - sourceString: The original source string to compare
///   - destString: The destination string to compare against
/// - Returns: An array of DiffOperation
/// - Throws: Diff creation errors
func createDiffFromDocument(
    sourceString: String,
    destString: String
) throws -> [DiffOperation] {
    // Create the diff using the existing createDiff function
    let diffOperations = createDiff(original: sourceString, modified: destString)
    
    return diffOperations
}

/// Applies a diff to a document
/// - Parameters:
///   - filePath: Path to the source document
///   - operations: The diff operations to apply
/// - Returns: True if successful, false otherwise
/// - Throws: File access, parsing, or application errors
func applyDiffToDocument(
    filePath: String,
    operations: [DiffOperation]
) throws -> Bool {
    // Resolve the file path
    let (resolvedPath, warning) = FuzzyLogicService.resolveFilePath(filePath)
    
    // Print warning if any
    if !warning.isEmpty {
        print(warning)
    }
    
    // Validate file exists
    guard FileManager.default.fileExists(atPath: resolvedPath) else {
        throw NSError(domain: "XcfSwiftDiff", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "File not found: \(filePath)"
        ])
    }
    
    // Read the original content using ScriptingBridge
    guard let originalContent = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) else {
        throw NSError(domain: "XcfSwiftDiff", code: 3, userInfo: [
            NSLocalizedDescriptionKey: "Failed to read document content"
        ])
    }
    
    // Apply the diff to the entire content using the existing applyDiff function
    let modifiedContent = try applyDiff(original: originalContent, operations: operations)
    
    // Write the modified content back to the file using ScriptingBridge
    if !XcfSwiftScript.shared.writeSwiftDocumentWithScriptingBridge(filePath: resolvedPath, content: modifiedContent) {
        throw NSError(domain: "XcfSwiftDiff", code: 4, userInfo: [
            NSLocalizedDescriptionKey: "Failed to write modified content to document"
        ])
    }
    
    return true
}
