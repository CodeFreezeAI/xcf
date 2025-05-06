//
//  AppleScripts.swift
//  ScriptAutomationTest
//
//  Created by Todd Bruss on 5/4/25.
//

func grantAutomation() -> String {
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
            
            return "Xcode Automation permission has been granted"
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
