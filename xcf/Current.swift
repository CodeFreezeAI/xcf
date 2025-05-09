//
//  Current.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

// These environment variables can be set in your MCP server configuration
// If you see variables with "_optional" suffix in example configs, remove the suffix when using them
var currentProject: String? = ProcessInfo.processInfo.environment["XCODE_PROJECT"] ?? XcfSwiftScript.shared.activeWorkspacePath()
var currentFolder : String? = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] ?? ProcessInfo.processInfo.environment["XCODE_PROJECT_FOLDER"]
