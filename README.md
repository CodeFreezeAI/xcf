# XCF - Xcode MCP Server

<div align="center">
  <h3>The Swift way to supercharge your AI workflow</h3>
  <p><a href="https://xcf.ai">xcf.ai</a> | Pure Swift. No TypeScript. No JavaScript. No BS.</p>
</div>

## Overview

XCF (XCodeFreeze) is a dedicated MCP (Machine Control Protocol) server designed specifically for Swift and Xcode development. It enables AI assistants like Claude to directly interact with your Xcode projects, streamlining your development workflow.

![XCF Alert](https://github.com/user-attachments/assets/e84c4ed5-2e17-4064-8871-b35f07af20e8)

## Installation

1. Install XCF to your Applications folder
2. Launch the app once to approve the internet download 
3. Click the "I Understand, Quit" button (XCF is a command-line MCP server)

> If XCF doesn't display the alert, code sign for local development:
> ```bash
> codesign --force --deep --sign - /Applications/xcf.app
> ```

Alternatively, you can build XCF from source using Xcode.

## Quick Setup

### Minimum Configuration

Add XCF to your MCP configuration file:

```json
{
  "mcpServers": {
    "xcf": {
      "type": "stdio",
      "command": "/Applications/xcf.app/Contents/MacOS/xcf server"
    }
  }
}
```

### Configuration Locations
- **Cursor**: `~/.cursor/mcp.json`
- **Claude Desktop**: `~/Library/Application Support/Claude/claude_desktop_config.json`

**Important**: Restart your AI assistant after setup or refresh the tool.

### Advanced Configuration

For non-Cursor clients or users requiring project-level control:

```json
{
  "mcpServers": {
    "xcf": {
      "type": "stdio",
      "command": "/Applications/xcf.app/Contents/MacOS/xcf server",
      "env": {
        "XCODE_PROJECT_FOLDER": "/path/to/project/",
        "XCODE_PROJECT": "/path/to/project/project.xcodeproj"
      }
    }
  }
}
```

These environment variables let you:
- Pre-select a specific Xcode project
- Define a custom workspace boundary for security

## Key Features

- **Zero Dependencies**: Standalone tool with no reliance on other MCP servers
- **Automatic Project Detection**: Auto-selects your Xcode project
- **Real-time Error Handling**: Sends errors and warnings from Xcode directly to your AI assistant
- **AI-Powered Fixes**: Let your AI assistant fix bugs and mistakes during coding sessions
- **Intuitive Commands**: Simple, developer-friendly command structure

## Commands Reference

### User Commands

| Command | Description |
|---------|-------------|
| `use xcf` | Activate xcf mode |
| `show` | List open Xcode projects |
| `open #` | Select project by number |
| `run` | Run current project |
| `build` | Build current project |
| `current` | Show selected project |
| `env` | Show environment variables |
| `help` | Display all available commands |

### Function-Based Tools

- `mcp_xcf_xcf`: Execute xcf actions/commands
- `mcp_xcf_list`: Show all available tools
- `mcp_xcf_snippet`: Access file contents
- `mcp_xcf_help`: Get help information

## Working with Code Snippets

### Using AI Function Calls

To retrieve an entire file:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", entireFile=true)
```

For specific line ranges:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", startLine=10, endLine=20)
```

### Using Human-Friendly Commands

For an entire file, just use the filename:
```
snippet filename.swift
```

For specific line ranges:
```
snippet /full/path/to/file.swift 10 20
```

### Smart Path Resolution

XCF intelligently searches for files in:

1. The current working directory
2. The workspace folder specified in the environment
3. Subdirectories (one level deep) in the workspace
4. The current project directory

## Security Features

- Safely works with projects in your designated workspace
- Prevents access outside workspace boundaries
- Redirects to safe alternatives when needed
- Uses environment variables to define secure boundaries

## Typical Workflow

1. `use xcf` - Activate the tool
2. `show` - See available projects
3. `open #` - Select a project 
4. `build` - Build the project
5. `run` - Run the project

## Demo

Watch XCF in action: [YouTube Demo](https://www.youtube.com/embed/7KfrsZfQIIg)

## Troubleshooting

If commands fail, verify:
- XCF installation is correct
- MCP server configuration is valid
- Permissions are properly set
- Environment variables with `env` command
- Try restarting your AI assistant

## Contributing

Swift engineers are welcome to contribute! Help us make XCF even better.

## Open Source

XCF is 100% Swift and 100% open source.  
[GitHub Repository](https://github.com/codefreezeai/xcf)

---

Created by XCodeFreeze Automation and CodeFreeze.ai
