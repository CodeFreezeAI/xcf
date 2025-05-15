//
//  modal.swift
//  xcf
//
//  Created by Todd Bruss on 5/15/25.
//

import AppKit

enum ModalDisplay {
    static func showServerRequiredAlert() {
        let alert = NSAlert()
        alert.messageText = "Use 'server' argument in your mcp.json"
        alert.informativeText = "/Applications/xcf.app/Contents/MacOS/xcf server"
        alert.alertStyle = .warning
        
        let quitButton = alert.addButton(withTitle: "Press to Quit this XCF Xcode MCP Server")
        quitButton.hasDestructiveAction = false
        quitButton.keyEquivalent = "\r" // Return key
        
        alert.runModal()
        exit(0)
    }
}
