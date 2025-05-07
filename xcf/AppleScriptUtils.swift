//
//  AppleScriptUtils.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation
import AppKit

// Extract string set from NSAppleEventDescriptor
func extractStringSet(from descriptor: NSAppleEventDescriptor) -> Set<String> {
    var result: Set<String> = [] // Ensure no duplicate items
    
    // Check if it's a list descriptor
    if descriptor.descriptorType == typeAEList {
        // Iterate through each item with `atIndex(_:)` (note: AppleScript indexing is 1-based, not 0-based)
        for index in 1...descriptor.numberOfItems {
            if let item = descriptor.atIndex(index) {
                if let string = item.stringValue {
                    result.insert(string)
                }
            }
        }
    }
    
    return result
}

// Convert Apple Script result to set
@discardableResult
func AppleScriptDescriptorToSet(script: String) -> Set<String> {
    // First try the modern Apple Event Descriptor approach
    if let appleScript = NSAppleScript(source: script) {
        var errorDict: NSDictionary? = nil
        let output = appleScript.executeAndReturnError(&errorDict)
        
        if let error = errorDict {
            print(String(format: ErrorMessages.appleScriptError, error.description))
            // Fall back to the regex approach
        } else {
            return extractStringSet(from: output)
        }
    } else {
        print(ErrorMessages.failedToCreateAppleScript)
    }
    
    // Fallback to the regex approach
    let result = executeWithOsascript(script: script)
    let descriptorStrings = result.split(separator: Format.commaSeparator)
    
    // Parse the result into a set
    var xcSet: Set<String> = []
    
    for ds in descriptorStrings {
        // Extract strings between quotes
        if let match = try? Format.quoteExtractPattern.wholeMatch(in: String(ds)) {
            xcSet.insert(String(match.1))
        }
    }
    
    return xcSet
} 
