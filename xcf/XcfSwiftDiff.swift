//
//  XcfSwiftDiff.swift
//  xcf
//
//  Created by Todd Bruss on 5/19/25.
//

import Foundation
import MultiLineDiff

var DiffOperationDict: [String : String] = [:]

func createDiff(original: String, modified: String) throws -> String {
    try MultiLineDiff.createBase64Diff(source: original, destination: modified)
}

func applyDiff(original: String, base64Diff: String) throws -> String {
    try MultiLineDiff.applyBase64Diff(to: original, base64Diff: base64Diff)
}

/// Applies a diff to a document
/// - Parameters:
///   - filePath: Path to the source document
///   - operations: The diff operations to apply
/// - Returns: True if successful, false otherwise
/// - Throws: File access, parsing, or application errors
func applyDiffToDocument(
    filePath: String,
    operations: String? = nil,
    diffUUID: String? = nil
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
    
    // Determine which diff operations to use
    let diffOperations: String
    if let uuid = diffUUID {
        // Try to retrieve diff operations from the dictionary
        guard let storedOperations = DiffOperationDict[uuid] else {
            throw NSError(domain: "XcfSwiftDiff", code: 5, userInfo: [
                NSLocalizedDescriptionKey: "No diff operations found for the given UUID"
            ])
        }
        diffOperations = storedOperations
    } else if let providedOperations = operations {
        // Use directly provided operations
        diffOperations = providedOperations
    } else {
        // No operations provided
        throw NSError(domain: "XcfSwiftDiff", code: 6, userInfo: [
            NSLocalizedDescriptionKey: "No diff operations provided"
        ])
    }
    
    // Read the original content using ScriptingBridge
    guard let originalContent = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) else {
        throw NSError(domain: "XcfSwiftDiff", code: 3, userInfo: [
            NSLocalizedDescriptionKey: "Failed to read document content"
        ])
    }
    
    // Apply the diff to the entire content using the existing applyDiff function
    let modifiedContent = try applyDiff(original: originalContent, base64Diff: diffOperations)
    
    // Write the modified content back to the file using ScriptingBridge
    if !XcfSwiftScript.shared.writeSwiftDocumentWithScriptingBridge(filePath: resolvedPath, content: modifiedContent) {
        throw NSError(domain: "XcfSwiftDiff", code: 4, userInfo: [
            NSLocalizedDescriptionKey: "Failed to write modified content to document"
        ])
    }
    
    return true
}

// Add new function to create diff from document and store in dictionary
func createDiffFromString(original: String, modified: String) throws -> String {
    
    // Create the diff operations
    let base64diff = try createDiff(original: original, modified: modified)
    
    let diffUUID = UUID().uuidString.lowercased()
    
    // Store the diff operations in the dictionary
    DiffOperationDict[diffUUID] = base64diff
    
    return diffUUID
}

// Add new function to create diff from document and store in dictionary
func applyDiffFromString(original: String, UUID: String) throws -> String {

    // Store the diff operations in the dictionary
    let diff = DiffOperationDict[UUID] ?? "Not Found"
    
    if diff == "Not Found" {
        return diff
    }
        
    // Create the diff operations
    do {
        let modified = try applyDiff(original: original, base64Diff: diff)
        return modified
    } catch {
        return error.localizedDescription
    }
}



// Add new function to create diff from document and store in dictionary
func createDiffFromDocument(
    filePath: String
) throws -> String {
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
    
    // Create a new UUID for this diff operation
    let diffUUID = UUID().uuidString.lowercased()
    
    // Create the diff operations
    let base64diff = try createDiff(original: originalContent, modified: originalContent)
    
    // Store the diff operations in the dictionary
    DiffOperationDict[diffUUID] = base64diff
    
    return diffUUID
}
