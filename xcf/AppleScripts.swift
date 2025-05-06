//
//  AppleScripts.swift
//  ScriptAutomationTest
//
//  Created by Todd Bruss on 5/4/25.
//

func OsaScriptBuildFirstOpenXCodeDocument() -> String {
    """
    tell application "Xcode"
        set xcDoc to first document
        
        tell xcDoc
            set buildResult to build
            
            repeat
                if completed of buildResult is true then
                    exit repeat
                end if
                delay 0.5
            end repeat
            
            return "Permission Granted"
        end tell
    end tell
    """
}

func getXcodeDocumentPaths(ext: String = ".xc") -> String {
    """
    tell application "Xcode"
        set p to get path of every document whose name contains "\(ext)"
        return p
    end tell
    """
}
