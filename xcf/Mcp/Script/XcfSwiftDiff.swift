//
//  XcfSwiftDiff.swift
//  xcf
//
//  Created by Todd Bruss on 5/19/25.
//

import Foundation
import MultiLineDiff

var DiffOperationDict: [String : DiffResult] = [:]

func createDiff(original: String, modified: String) -> DiffResult {
    MultiLineDiff.createDiff(source: original, destination: modified)
}
//MultiLineDiff.createUndoDiff(from: <#T##DiffResult#>)

func applyDiff(original: String, diff: DiffResult) throws -> String {
    try MultiLineDiff.applyDiff(to: original, diff: diff)
}

/// Resolves and validates a file path
/// - Parameter filePath: The file path to resolve and validate
/// - Returns: The resolved path
/// - Throws: NSError if the file doesn't exist
private func resolveAndValidateFilePath(_ filePath: String) throws -> String {
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
    
    return resolvedPath
}

/// Resolves diff operations from either a hash or direct operations
/// - Parameters:
///   - operations: Optional direct diff operations
///   - diffHash: Optional hash to retrieve operations from dictionary
/// - Returns: The resolved diff operations
/// - Throws: NSError if no valid operations are found
private func resolveDiffOperations(operations: DiffResult?, diffHash: String?) throws -> DiffResult {
    // Determine which diff operations to use
    if let diffHash = diffHash {
        // Try to retrieve diff operations from the dictionary
        guard let storedOperations = DiffOperationDict[diffHash] else {
            throw NSError(domain: "XcfSwiftDiff", code: 5, userInfo: [
                NSLocalizedDescriptionKey: "No diff operations found for the given hash"
            ])
        }
        return storedOperations
    } else if let providedOperations = operations {
        // Use directly provided operations
        return providedOperations
    } else {
        // No operations provided
        throw NSError(domain: "XcfSwiftDiff", code: 6, userInfo: [
            NSLocalizedDescriptionKey: "No diff operations provided"
        ])
    }
}

/// Applies a diff to a document
/// - Parameters:
///   - filePath: Path to the source document
///   - operations: The diff operations to apply
/// - Returns: True if successful, false otherwise
/// - Throws: File access, parsing, or application errors
func applyUndoDiffToDocument(
    filePath: String,
    operations: DiffResult? = nil,
    diffHash: String? = nil
) throws -> Bool {
    // Resolve and validate the file path
    let resolvedPath = try resolveAndValidateFilePath(filePath)
    
    // Get the diff operations
    let diffOperations = try resolveDiffOperations(operations: operations, diffHash: diffHash)
    
    // Verify diff integrity
    let isValid = MultiLineDiff.verifyDiff(diffOperations)
    print("Diff is valid: \(isValid)")

    // Read the original content using ScriptingBridge
    guard let destination = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) else {
        throw NSError(domain: "XcfSwiftDiff", code: 3, userInfo: [
            NSLocalizedDescriptionKey: "Failed to read document content"
        ])
    }
    
    var originalContent: String = ""
    
    // Create automatic undo diff
    if let undoDiff = MultiLineDiff.createUndoDiff(from: diffOperations) {
        originalContent = try MultiLineDiff.applyDiff(to: destination, diff: undoDiff)
    }

    // Write the modified content back to the file using ScriptingBridge
    if !originalContent.isEmpty && !XcfSwiftScript.shared.writeSwiftDocumentWithScriptingBridge(filePath: resolvedPath, content: originalContent) {
        throw NSError(domain: "XcfSwiftDiff", code: 4, userInfo: [
            NSLocalizedDescriptionKey: "Failed to write modified content to document"
        ])
    }
    
    if originalContent.isEmpty { return false }
    
//    if !XcfSwiftScript.shared.writeSwiftDocumentWithFileManager(filePath: resolvedPath, content: modifiedContent) {
//            throw NSError(domain: "XcfSwiftDiff", code: 4, userInfo: [
//                NSLocalizedDescriptionKey: "Failed to write modified content to document"
//            ])
//        }
    
    return true
}

/// Applies a diff to a document
/// - Parameters:
///   - filePath: Path to the source document
///   - operations: The diff operations to apply
/// - Returns: True if successful, false otherwise
/// - Throws: File access, parsing, or application errors
func applyDiffToDocument(
    filePath: String,
    operations: DiffResult? = nil,
    diffHash: String? = nil
) throws -> Bool {
    // Resolve and validate the file path
    let resolvedPath = try resolveAndValidateFilePath(filePath)
    
    // Get the diff operations
    let diffOperations = try resolveDiffOperations(operations: operations, diffHash: diffHash)
    
    // Read the original content using ScriptingBridge
    guard let originalContent = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) else {
        throw NSError(domain: "XcfSwiftDiff", code: 3, userInfo: [
            NSLocalizedDescriptionKey: "Failed to read document content"
        ])
    }
    
    // Apply the diff to the entire content using the existing applyDiff function
    let modifiedContent = try applyDiff(original: originalContent, diff: diffOperations)
    
    // Write the modified content back to the file using ScriptingBridge
    if !XcfSwiftScript.shared.writeSwiftDocumentWithScriptingBridge(filePath: resolvedPath, content: modifiedContent) {
        throw NSError(domain: "XcfSwiftDiff", code: 4, userInfo: [
            NSLocalizedDescriptionKey: "Failed to write modified content to document"
        ])
    }
    
//    if !XcfSwiftScript.shared.writeSwiftDocumentWithFileManager(filePath: resolvedPath, content: modifiedContent) {
//            throw NSError(domain: "XcfSwiftDiff", code: 4, userInfo: [
//                NSLocalizedDescriptionKey: "Failed to write modified content to document"
//            ])
//        }
    
    return true
}

// Add new function to create diff from document and store in dictionary
func createDiffFromString(original: String, modified: String) throws -> String {
    
    // Create the diff operations
    let diffResult = createDiff(original: original, modified: modified)
    
    guard let diffHash = diffResult.metadata?.diffHash else {
        return "The Diff did not create a hash"
    }
    
    // Store the diff operations in the dictionary
    DiffOperationDict[diffHash] = diffResult
    
    return diffHash
}

// Add new function to create diff from document and store in dictionary
func applyDiffFromString(original: String, diffHash: String) throws -> String {

    // Store the diff operations in the dictionary
    guard let diff = DiffOperationDict[diffHash] else {
        return "Diff hash not found"
    }
    
    // Create the diff operations
    return try applyDiff(original: original, diff: diff)

}

// Add new function to create diff from document and store in dictionary
func createDiffFromDocument(filePath: String, modifiedContent: String) throws -> String {
    // Resolve and validate the file path
    let resolvedPath = try resolveAndValidateFilePath(filePath)
    
    // Read the original content using ScriptingBridge
    guard let originalContent = XcfSwiftScript.shared.readSwiftDocumentWithScriptingBridge(filePath: resolvedPath) else {
        throw NSError(domain: "XcfSwiftDiff", code: 3, userInfo: [
            NSLocalizedDescriptionKey: "Failed to read document content"
        ])
    }
    
    // Create the diff operations
    let diffResult = createDiff(original: originalContent, modified: modifiedContent)
    
    // Create a new hash for this diff operation
    let diffHash = diffResult.metadata?.diffHash ?? "Diff hash is missing"

    // Store the diff operations in the dictionary
    DiffOperationDict[diffHash] = diffResult
    
    return diffHash
}
