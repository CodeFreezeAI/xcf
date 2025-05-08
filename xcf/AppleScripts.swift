//
//  AppleScripts.swift
//  xcf
//
//  Created by Todd Bruss on 5/4/25.
//

//MARK: Some Systems only approve over OSAScript - this is a workaround, may not be needed on all systems
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