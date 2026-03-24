# 🚀 XCF Xcode MCP Server 

## The Swift way to Super Charge your AI Workflow!

[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Website](https://img.shields.io/badge/website-xcf.ai-blue.svg)](https://xcf.ai)
[![Version](https://img.shields.io/badge/version-1.0.5-green.svg)](https://github.com/toddbruss/xcf)
[![GitHub downloads](https://img.shields.io/github/downloads/codefreezeai/xcf/total.svg)](https://github.com/codefreezeai/xcf/releases)
[![GitHub stars](https://img.shields.io/github/stars/codefreezeai/xcf.svg?style=social)](https://github.com/codefreezeai/xcf/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/codefreezeai/swift-multi-line-diff.svg?style=social)](https://github.com/codefreezeai/xcf/network)

### 🖌️ New features in 1.0.5!
- ✅ File & Directory Operations
- ✅ Scripting Bridge Xcode Doc Operations
- ✅ Fuzzy Logic Path Resolution
- ✅ Swift Code Analysis (without building in Xcode)
- ✅ 21 MCP Tools for Xcode Automation

Speed up writing Xcode apps with xcf, a dead simple Swift-based MCP server designed for Cursor, Claude Code, and VSCode — no TypeScript, no JavaScript, no BS!

## 🧰 XCF Installation & Configuration

### Installation Steps

1. Download the XCF application and drag it to your /Applications folder.
2. Launch the application to approve the internet download.

<img width="372" alt="Screenshot 2025-05-11 at 9 15 35 PM" src="https://github.com/user-attachments/assets/da8fe321-7292-4985-a08e-c07ed2f9be59" />

4. You will see the following alert (this is expected):

<img width="414" alt="XCF Alert" src="https://github.com/user-attachments/assets/e84c4ed5-2e17-4064-8871-b35f07af20e8" />

6. Click the "Press to Quit this XCF Xcode MCP Server" button.

> 💡 **Troubleshooting:** If XCF doesn't display the alert, run this command:
> ```bash
> codesign --force --deep --sign - /Applications/xcf.app
> ```

You can also build xcf from source using Xcode. It's 100% Swift and easy to build locally.

## 🔧 Quick Setup

### Minimum Requirements:

Add xcf to your MCP configuration file:

```json
{
  "mcpServers": {
    "xcf": {
      "type": "stdio",
      "command": "Applications/xcf.app/Contents/MacOS/xcf",
      "args": ["server"]
    }
  }
}          
```

### Configuration Locations
- **Cursor**: `~/.cursor/mcp.json`
- **Claude Desktop**: `~/Library/Application Support/Claude/claude_desktop_config.json`

⚠️ **Important:** Restart your AI assistant after setup or refresh the tool.

## ⚙️ Advanced Configuration

For non-Cursor clients or users requiring strict project-level control:

```json
{
  "mcpServers": {
    "xcf": {
      "type": "stdio",
      "command": "Applications/xcf.app/Contents/MacOS/xcf",
      "args": ["server"],
      "env": {
          "XCODE_PROJECT_FOLDER": "/path/to/project/",
          "XCODE_PROJECT": "/path/to/project/project.xcodeproj"
      }
    }
  }
}
```

These environment variables let you:
- Pre-select a specific Xcode project to work with
- Define a custom workspace boundary for security

## ✨ Key Features

- **Zero Dependencies:** Easy to install, no reliance on other MCP servers
- **Automatic Project Detection:** Auto-selects your Xcode project so you can start coding immediately
- **Real-time Error Handling:** `xcf build` or `xcf run` sends errors and warnings from Xcode directly to your AI IDE
- **AI-Powered Fixes:** Let Claude fix bugs and mistakes during your coding sessions
- **Intuitive Commands:** Simple, developer-friendly command structure for maximum productivity
- **Comprehensive File Operations:** Read files and directories with ease
- **Xcode Integration:** Build, run, and manage Xcode projects directly
- **Advanced Code Analysis:** Get detailed Swift code analysis without building in Xcode

## 🛠️ Perfect for Swift Developers

The tool is designed by Swift developers, for Swift developers. Commands like `build`, `run`, `show`, and our new file and directory operations make the workflow intuitive and natural.

## 📋 Commands Reference

| xcf Command | action Description |
|---------|-------------|
| `show` | List open Xcode projects |
| `open #` | Select project by number |
| `run` | Run current project |
| `build` | Build current project |
| `current` | Show selected project |
| `env` | Show environment variables |
| `pwd` | Show current folder (aliases: dir, path) |
| `help` | Display all available commands |

### File Operations
| Command | Description |
|---------|-------------|
| `read_file <file>` | Read content from a file |
| `read_dir [path] [extension]` | List directory contents |
| `cd_dir <path>` | Change directory |

### Analysis Tools
| Command | Description |
|---------|-------------|
| `snippet <file> [start] [end]` | Extract code snippets |
| `analyzer <file> [start] [end]` | Analyze Swift code |
| `lz <file>` | Shorthand for analyzer |

## 📄 Using Snippets

### For Human Commands

xcf supports simplified, user-friendly snippet commands:

To get an entire file, just use the filename:
```
xcf snippet filename.swift
```

No need for full paths in many cases - xcf will intelligently find and display the complete file contents.

For specific line ranges:
```
xcf snippet filename.swift 10 20
```

You can use either format for file operations:

```
xcf snippet /path/to/file.swift                 // Direct path
xcf snippet filePath=/path/to/file.swift        // Named parameter

xcf analyze /path/to/file.swift                 // Direct path
xcf analyze filePath=/path/to/file.swift        // Named parameter

xcf lz /path/to/file.swift                      // Direct path (shorthand)
xcf lz filePath=/path/to/file.swift             // Named parameter (shorthand)
```

For specific line ranges:
```
xcf snippet /path/to/file.swift 10 20           // Direct path with line range
xcf snippet filePath=/path/to/file.swift startLine=10 endLine=20  // Named parameters
```

### For AI Assistants

When using xcf through MCP tools, use this syntax:

```
mcp_xcf_snippet filePath="filename.swift" entireFile=true
```

For specific line ranges:
```
mcp_xcf_snippet filePath="filename.swift" startLine=10 endLine=20
```

### Smart Path Resolution

When a file isn't found at the exact path, xcf will intelligently search for it in:

1. First tries the exact path provided
2. Resolves relative paths using the current working directory
3. Searches in the current project directory and one level up
4. Searches in the workspace folder defined by WORKSPACE_FOLDER_PATHS
5. Searches recursively in workspace folders with limited depth
6. As a last resort, performs a fuzzy search for similar filenames

This smart path resolution is used consistently across ALL file operations in xcf, including:
- File reading and code snippets
- Code analysis
- Directory operations

This means you can usually just use the filename without any path for any operation:

```
xcf snippet Constants.swift    // For humans
xcf analyze Constants.swift    // For humans
```

Or for AI assistants:

```
mcp_xcf_snippet filePath="Constants.swift" entireFile=true
mcp_xcf_analyzer filePath="Constants.swift" entireFile=true
```

## 🔍 Swift Code Analysis

### For Human Commands

Analyze an entire Swift file for potential issues:
```
xcf analyze filename.swift
```

Or use the shorthand version:
```
xcf lz filename.swift
```

For specific line ranges:
```
xcf analyze filename.swift --startLine 10 --endLine 50
```

### For AI Assistants

When using xcf through MCP tools, use this syntax:

```
mcp_xcf_analyzer filePath="filename.swift" entireFile=true
```

Or use the shorthand version:
```
mcp_xcf_xcf action="lz filename.swift"
```

For specific line ranges:
```
mcp_xcf_analyzer filePath="filename.swift" startLine=10 endLine=50
```

The analysis identifies issues like:
- Code style and formatting problems
- Functions with high complexity
- Unused variables and symbols
- Magic numbers
- Long methods
- And more

## 🧩 MCP Tools (21 Tools)

### Core Tools

| Tool | Description |
|------|-------------|
| `xcf` | Execute xcf actions (show, open, build, run, current, env, pwd, analyze, lz) |
| `list` | Lists all available tools on this server |
| `xcf_help` | Quick help for xcf actions only |
| `help` | Regular help with common examples |
| `use_xcf` | Activate XCF mode |
| `tools` | Show detailed reference for all tools including AI function calls |
| `show_help` | Display help information about available commands |

### Project Management Tools

| Tool | Description |
|------|-------------|
| `build_project` | Build the current Xcode project |
| `run_project` | Run the current Xcode project |
| `list_projects` | List all open Xcode projects |
| `select_project` | Select an Xcode project by number |
| `show_current_project` | Show information about the currently selected project |
| `show_env` | Display all environment variables |
| `show_folder` | Display the current working folder |
| `grant_permission` | Grant Xcode automation permissions |

### File System Tools

| Tool | Description |
|------|-------------|
| `read_file` | Read content from a file |
| `read_dir` | List contents of a directory |
| `cd_dir` | Change current directory |

### Code Analysis Tools

| Tool | Description |
|------|-------------|
| `snippet` | Extract code snippets from files |
| `analyzer` | Analyze Swift code for potential issues |
| `analyze_swift_code` | Analyze Swift code with customizable check groups (syntax, style, safety, performance, bestPractices) |

### For AI Function Calls

To get an entire file:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", entireFile=true)
```

For specific line ranges:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", startLine=10, endLine=20)
```

To analyze an entire file:
```
mcp_xcf_analyzer(filePath="/full/path/to/file.swift", entireFile=true)
```

For specific line ranges:
```
mcp_xcf_analyzer(filePath="/full/path/to/file.swift", startLine=10, endLine=50)
```

### Working with Files and Directories

Read a file:
```
mcp_xcf_read_file filePath="main.swift"
```

List directory contents:
```
mcp_xcf_read_dir directoryPath="."
```

List Swift files only:
```
mcp_xcf_read_dir directoryPath="src" fileExtension="swift"
```

Change directory:
```
mcp_xcf_cd_dir directoryPath="src"
```

## 🔒 Security Features

- Safely works with projects in your designated workspace
- Automatically prevents access outside your workspace boundaries
- Redirects to safe alternatives when needed
- Uses environment variables to define secure boundaries

## 🔄 Workflow Examples

### Basic Workflow (For Humans)
1. `xcf show` - See available projects
2. `xcf open 1` - Select a project 
3. `xcf build` - Build the project
4. `xcf run` - Run the project

### Code Analysis Workflow (For Humans)
1. `xcf current` - Check current project
2. `xcf snippet filename.swift` - Examine code
3. `xcf lz filename.swift` - Analyze code
4. `xcf build` - Build after fixing issues

### File Manipulation Workflow (For Humans)
1. `read_dir .` - List files in current directory
2. `read_file main.swift` - View file contents
3. Use Agent native tools for file editing
4. `xcf build` - Build after changes

### Basic Workflow (For AI Assistants)
2. `mcp_xcf_xcf action="show"` - See available projects
3. `mcp_xcf_xcf action="open 1"` - Select a project 
4. `mcp_xcf_xcf action="build"` - Build the project
5. `mcp_xcf_xcf action="run"` - Run the project

### Code Analysis Workflow (For AI Assistants)
2. `mcp_xcf_xcf action="current"` - Check current project
3. `mcp_xcf_snippet filePath="filename.swift" entireFile=true` - Examine code
4. `mcp_xcf_analyzer filePath="filename.swift" entireFile=true` - Analyze code
5. `mcp_xcf_xcf action="build"` - Build after fixing issues

### File Manipulation Workflow (For AI Assistants)
2. `mcp_xcf_read_dir directoryPath="."` - List files in current directory
3. `mcp_xcf_read_file filePath="main.swift"` - View file contents
4. Use Agent native `edit_file` tool for file editing
5. `mcp_xcf_xcf action="build"` - Build after changes

## 📺 Demo

Watch XCF in action: [YouTube Demo](https://www.youtube.com/embed/7KfrsZfQIIg)

## ❓ Troubleshooting

If commands fail, check:
- xcf installation is correct
- Refreshing xcf MCP Server
- Verify the server launches and is in your /Applications folder
- Environment variables with `env` such as "server"
- Relaunch your AI assistant

## 🤝 Open Source Community

Swift Engineers are welcome to contribute! Help us make xcf even better.

## 💯 100% Swift. 100% Open Source.  
[GitHub Repository](https://github.com/codefreezeai/xcf)

---

Created by XCodeFreeze Automation and CodeFreeze.ai - Bringing the future of Swift development to your fingertips!