//
//  XcfDirectiveHandler.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import Foundation

@MainActor
struct XcfDirectiveHandler {
    // Main entry point for handling directives
    static func handleDirective(directive: String) async -> String {
        // Convert directive to lowercase for case-insensitive matching
        let lowercasedDirective = directive.lowercased()
       
        switch lowercasedDirective {
        case Directives.xcf, Directives.useXcf:
            return SuccessMessages.xcfActive
        case Directives.help, Directives.xcf + " " + Directives.help:
            return getHelpText()
        case Directives.grant:
            return grantPermission()
        case Directives.run:
            return await runProject()
        case Directives.build:
            return await buildProject()
            
        // List projects
        case let cmd where cmd.starts(with: Directives.list):
            return listProjects()
            
        // Select project
        case let cmd where cmd.starts(with: Directives.select):
            return selectProject(directive: directive)
            
        default:
            // No recognized directive
            return String(format: ErrorMessages.unrecognizedDirective, directive)
        }
    }
    
    // Get help information
    private static func getHelpText() -> String {
        return McpConfig.helpText
    }
    
    // Grant permission to use Xcode automation
    private static func grantPermission() -> String {
        // May not be needed anymore... leave for now.
        let script = grantAutomation()
        return executeWithOsascript(script: script)
    }
    
    // Run the current project
    private static func runProject() async -> String {
        guard let currentProject else { return ErrorMessages.noProjectSelected }
        let XcodeBuildScript = XcodeBuildScript()
        let buildCheckForErrors = XcodeBuildScript.buildCurrentWorkspace(projectPath: currentProject, run: false)
        
        if buildCheckForErrors.contains(StatusKeywords.success) {
            return XcodeBuildScript.buildCurrentWorkspace(projectPath: currentProject, run: true)
        } else {
            return buildCheckForErrors
        }
    }
    
    // Build the current project
    private static func buildProject() async -> String {
        guard let currentProject else { return ErrorMessages.noProjectSelected }
        return XcodeBuildScript().buildCurrentWorkspace(projectPath: currentProject, run: false)
    }
    
    // List all open Xcode projects
    private static func listProjects() -> String {
        let xcArray = getSortedXcodeProjects()

        if xcArray.isEmpty {
            return ErrorMessages.noOpenProjects
        }
        
        return getOpenProjectsList(projs: xcArray)
    }
    
    // Select a project by number
    private static func selectProject(directive: String) -> String {
        // Parse the project number
        let projectNumber = parseProjectNumber(from: directive)
        
        // Check if the project number is valid
        guard let projectNumber = projectNumber else {
            return ErrorMessages.invalidProjectSelection
        }
        
        // Get the list of projects
        let xcArray = getSortedXcodeProjects()
        
        // Check if there are any projects
        guard !xcArray.isEmpty else {
            return ErrorMessages.noOpenProjects
        }
        
        // Check if the project number is in range
        guard (1...xcArray.count).contains(projectNumber) else {
            return String(format: ErrorMessages.projectOutOfRange, "\(projectNumber)", "\(xcArray.count)")
        }
        
        // Select the project
        currentProject = xcArray[projectNumber - 1]
        return String(format: SuccessMessages.projectSelected, projectNumber, currentProject ?? "")
    }
    
    // Parse the project number from a directive
    private static func parseProjectNumber(from directive: String) -> Int? {
        let parts = directive.split(separator: " ")
        guard parts.count >= 2, let n = Int(parts[1]) else { return nil }
        return n
    }
    
    // Get a sorted list of open Xcode projects
    private static func getSortedXcodeProjects(ext: String = FileFormats.xcodeFileExtension) -> [String] {
        let xc = AppleScriptDescriptorToSet(script: getXcodeDocumentPaths(ext: ext))
        return Array(xc).sorted() // Convert Set to Array and sort alphabetically
    }
    
    // Get a formatted list of open projects
    private static func getOpenProjectsList(projs: [String]) -> String {
        var result = ""
        
        for (index, proj) in projs.enumerated() {
            result += String(format: FileFormats.projectListFormat, index + 1, proj)
        }
        
        return result
    }
} 
