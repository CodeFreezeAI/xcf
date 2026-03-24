//
//  XcfHelpText.swift
//  xcf
//
//  Created by Todd Bruss on 5/18/25.
//

import Foundation

// Define help text
struct HelpText {
    // Help text showing all available actions
    static let basic = """
XCF Actions (use via xcf tool with action parameter):

Project Actions:
  grant              Grant Xcode automation permissions
  show               List open projects
  open <n>           Select project by number
  current            Show selected project
  build              Build current project
  run                Run current project

File Actions:
  read <file>        Read file contents
  snippet <file>     Extract entire file as code snippet
  snippet <f> <s> <e> Extract lines s to e as code snippet
  readdir [path] [ext] List directory contents
  cd <path>          Change directory

Analysis Actions:
  analyze <file>           Analyze Swift code (all checks)
  analyze <f> <s> <e>      Analyze lines s to e
  analyze <f> <checks...>  Analyze with specific checks
  lz <file>                Short for analyze

Utility Actions:
  env                Show environment variables
  pwd                Show current folder (aliases: dir, path)
  help               Show this help

Examples:
  xcf action="build"
  xcf action="run"
  xcf action="show"
  xcf action="open 1"
  xcf action="read main.swift"
  xcf action="snippet main.swift 10 20"
  xcf action="readdir src swift"
  xcf action="cd src"
  xcf action="analyze main.swift"
  xcf action="analyze main.swift syntax style"
  xcf action="lz main.swift"

Notes:
- All paths can be relative, in subdirectories, parent dirs, or absolute
- Line numbers are 1-indexed
- Available check groups: all, syntax, style, safety, performance, bestPractices
- Available checks: syntax, unusedVars, immutables, unreachable, forcedUnwraps,
                   operators, style, refactor, symbols, macros, complexity,
                   guards, longMethods, emptyCatch, optionalChain, naming
"""

    // Kept for backward compatibility
    static let detailed = basic
    static let toolsReference = basic
}
