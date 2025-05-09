//
//  Current.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

import Foundation

var currentProject: String? = ProcessInfo.processInfo.environment["XCODE_PROJECT"] ?? XcfSwiftScript.shared.activeWorkspacePath()
var currentFolder : String? = ProcessInfo.processInfo.environment["WORKSPACE_FOLDER_PATHS"] ?? ProcessInfo.processInfo.environment["XCODE_PROJECT_FOLDER"]
