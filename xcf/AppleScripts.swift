//
//  AppleScripts.swift
//  ScriptAutomationTest
//
//  Created by Todd Bruss on 5/4/25.
//

func OsaScriptBuildAndRun(projectPath: String) -> String {
    """
    tell application "Xcode"
        set xcDoc to open "\(projectPath)"
        
        tell xcDoc
            set buildResult to run
            
            repeat
                if completed of buildResult is true then
                    exit repeat
                end if
                delay 0.5
            end repeat
            
            return "🍏📜 Ran successfully"
        end tell
    end tell
    """
}

func AppleScriptBuildAndRun(projectPath: String) -> String {
    """
    tell application "Xcode"
        set xcDoc to open "\(projectPath)"
        
        tell xcDoc
            set buildResult to run
            
            repeat
                if completed of buildResult is true then
                    exit repeat
                end if
                delay 0.5
            end repeat
            
            set buildResults to ""
            
            set buildErrors to (build errors of buildResult)
            repeat with currentError in buildErrors
                set errorMessage to message of currentError
                set filePath to file path of currentError
                set lineNum to starting line number of currentError
                
                if filePath is missing value then
                    set buildResults to buildResults & "Error: " & errorMessage & return
                else
                    set buildResults to (buildResults & "Error: " & errorMessage & " in " & filePath & " (line " & lineNum as string) & ")" & return
                end if
            end repeat
            
            if buildResults is "" then
                return "🍎📜 Ran successfully"
            else
                return buildResults
            end if
        end tell
    end tell
    """
}

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
