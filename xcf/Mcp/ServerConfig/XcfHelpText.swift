//
//  XcfHelpText.swift
//  xcf
//
//  Created by Todd Bruss on 5/18/25.
//

import Foundation

// Define help text
struct HelpText {
    // Quick help for xcf actions only
    static let basic = """
XCF Actions:
grant - Grant Xcode automation permissions
show - List open projects
open # - Select project by number
current - Show selected project
build - Build current project
run - Run current project
env - Show environment variables
pwd - Show current folder (aliases: dir, path)
analyze <file> - Analyze Swift code
lz <file> - Short for analyze

Examples:
xcf show
xcf open 1
xcf current
xcf build
xcf run
xcf analyze main.swift
xcf lz main.swift
"""

    // Regular help with common examples
    static let detailed = """
Tool Commands:

File Tools:
read_file <file>
Read content from a file
Example: read_file main.swift
Example: read_file src/utils.swift
Example: read_file ../shared/config.swift
Example: read_file ../../other/project/file.swift
Example: read_file /Users/username/Projects/app/main.swift

write_file <file> <content>
Write content to a file
Example: write_file test.txt "Hello World"
Example: write_file src/config.json '{"key": "value"}'
Example: write_file ../shared/types.swift 'import Foundation'

edit_file <file> <start> <end> <content>
Edit specific lines in a file
Example: edit_file main.swift 10 20 "new content"
Example: edit_file src/test.swift 5 5 "import UIKit"
Example: edit_file ../shared/types.swift 1 10 "new code"

delete_file <file>
Delete a file
Example: delete_file test.txt
Example: delete_file src/old/backup.swift
Example: delete_file ../backup/old.swift

Directory Tools:
cd_dir <path>
Change directory
Example: cd_dir .
Example: cd_dir src
Example: cd_dir ..
Example: cd_dir ../shared

read_dir [path] [extension]
List directory contents
Example: read_dir .
Example: read_dir src
Example: read_dir ../shared
Example: read_dir src swift

add_dir <path>
Create directory
Example: add_dir utils
Example: add_dir src/models
Example: add_dir ../shared/types

rm_dir <path>
Remove directory
Example: rm_dir temp
Example: rm_dir src/cache
Example: rm_dir ../old

Xcode Tools:
open_doc <file>
Open document in Xcode
Example: open_doc main.swift
Example: open_doc src/views/main.swift
Example: open_doc ../shared/helpers.swift

create_doc <file> [content]
Create new Xcode document
Example: create_doc test.swift
Example: create_doc src/models/user.swift
Example: create_doc ../shared/types.swift

read_doc <file>
Read Xcode document
Example: read_doc main.swift
Example: read_doc src/views/main.swift
Example: read_doc ../shared/helpers.swift

save_doc <file>
Save Xcode document
Example: save_doc main.swift
Example: save_doc src/views/main.swift
Example: save_doc ../shared/helpers.swift

edit_doc <file> <start> <end> <content>
Edit Xcode document
Example: edit_doc main.swift 10 20 "new code"
Example: edit_doc src/views/main.swift 5 10 "new code"
Example: edit_doc ../shared/helpers.swift 1 5 "new code"

Analysis Tools:
snippet <file> [start] [end]
Extract code snippets
Example: snippet main.swift
Example: snippet src/utils.swift
Example: snippet ../shared/types.swift
Example: snippet main.swift 10 20

analyzer <file> [start] [end]
Analyze Swift code
Example: analyzer main.swift
Example: analyzer src/models/user.swift
Example: analyzer ../shared/types.swift
Example: analyzer main.swift 10 20

Notes:
- All paths can be:
  - In current directory: file.swift
  - In child directories: src/file.swift
  - In parent directory: ../file.swift
  - Multiple directories up: ../../file.swift
  - Full system paths: /Users/username/project/file.swift
- Content with spaces should be quoted
- Use either ' or " for quoting content
"""

    // Super detailed help with all tools and examples
    static let toolsReference = """
MCP Tool Reference

Core Tools:
xcf
Description: Execute an xcf action or command
Required Parameters:
  - action: string (The xcf action to execute)
Example: mcp_xcf_xcf action="build"
Example: mcp_xcf_xcf action="run"

list
Description: Lists all available tools on this server
Parameters: none (type: string)
Example: mcp_xcf_list

xcf_help
Description: Quick help for xcf commands
Parameters: none (type: string)
Example: mcp_xcf_xcf action="xcf_help"

help
Description: Regular help with common examples
Parameters: none (type: string)
Example: mcp_xcf_xcf action="help"

File Operations:
snippet
Description: Extract code snippets from files in the current project
Required Parameters:
  - filePath: string (Path to the file to extract snippet from)
Optional Parameters:
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - entireFile: boolean (Set to true to get the entire file content)
Example: mcp_xcf_snippet filePath="main.swift" entireFile=true
Example: mcp_xcf_snippet filePath="main.swift" startLine=10 endLine=20

analyzer
Description: Analyze Swift code for potential issues
Required Parameters:
  - filePath: string (Path to the file to extract snippet from)
Optional Parameters:
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - entireFile: boolean (Set to true to get the entire file content)
Example: mcp_xcf_analyzer filePath="main.swift" entireFile=true
Example: mcp_xcf_analyzer filePath="main.swift" startLine=10 endLine=20

read_dir
Description: List contents of a directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Optional Parameters:
  - fileExtension: string (Filter files by extension, e.g., 'swift')
Example: mcp_xcf_read_dir directoryPath="src"
Example: mcp_xcf_read_dir directoryPath="src" fileExtension="swift"

write_file
Description: Write content to a file
Required Parameters:
  - filePath: string (Path to the file to write to)
  - content: string (Content to write to the file)
Example: mcp_xcf_write_file filePath="main.swift" content="print(\"Hello\")"

read_file
Description: Read content from a file
Required Parameters:
  - filePath: string (Path to the file to read from)
Example: mcp_xcf_read_file filePath="main.swift"

cd_dir
Description: Change current directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Example: mcp_xcf_cd_dir directoryPath="src"

edit_file
Description: Edit content in a file
Required Parameters:
  - filePath: string (Path to the file to edit)
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - replacement: string (Replacement text for the specified lines)
Example: mcp_xcf_edit_file filePath="main.swift" startLine=10 endLine=20 replacement="new code"

delete_file
Description: Delete a file
Required Parameters:
  - filePath: string (Path to the file to delete)
Example: mcp_xcf_delete_file filePath="old.swift"

Directory Operations:
add_dir
Description: Create a new directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Example: mcp_xcf_add_dir directoryPath="src/models"

rm_dir
Description: Remove a directory
Required Parameters:
  - directoryPath: string (Path to the directory)
Example: mcp_xcf_rm_dir directoryPath="old"

Xcode Document Operations:
open_doc
Description: Open a document in Xcode
Required Parameters:
  - filePath: string (Path to the file to open)
Example: mcp_xcf_open_doc filePath="main.swift"

create_doc
Description: Create a new document in Xcode
Required Parameters:
  - filePath: string (Path to the file to create)
Optional Parameters:
  - content: string (Content to write to the file)
Example: mcp_xcf_create_doc filePath="new.swift"
Example: mcp_xcf_create_doc filePath="new.swift" content="import Foundation"

read_doc
Description: Read document content from Xcode
Required Parameters:
  - filePath: string (Path to the file to read)
Example: mcp_xcf_read_doc filePath="main.swift"

save_doc
Description: Save document in Xcode
Required Parameters:
  - filePath: string (Path to the file to save)
Example: mcp_xcf_save_doc filePath="main.swift"

edit_doc
Description: Edit document content in Xcode
Required Parameters:
  - filePath: string (Path to the file to edit)
  - startLine: integer (Starting line number, 1-indexed)
  - endLine: integer (Ending line number, 1-indexed)
  - replacement: string (Replacement text for the specified lines)
Example: mcp_xcf_edit_doc filePath="main.swift" startLine=10 endLine=20 replacement="new code"

Mode Activation:
use_xcf
Description: Activate XCF mode
Parameters: none (type: string)
Example: mcp_xcf_use_xcf

Parameter Types:
- string: Text values, use quotes for values with spaces
- integer: Whole numbers, 1-indexed for line numbers
- boolean: true or false
- object: Complex parameter type containing multiple values

Notes:
- All file paths can be:
  - Relative to current directory: main.swift
  - In subdirectories: src/main.swift
  - In parent directory: ../main.swift
  - Full system paths: /Users/username/project/main.swift
- Line numbers are always 1-indexed
- Content with spaces must be quoted
- Boolean values are specified as true or false (lowercase)
- All MCP calls start with mcp_xcf_
"""
}