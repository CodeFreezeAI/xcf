# xcf - AI-Powered Xcode Automation

A simple MCP server that lets AI assistants control Xcode. Works with Cursor, VSCode and Claude Desktop.

## Quick Setup

Add xcf to your MCP config:

```json
{
  "mcpServers": {
    "xcf": {
      "type": "stdio",
      "command": "/path/to/xcf"
    }
  }
}
```

Config location:
- Cursor: `~/.cursor/mcp.json`
- Claude Desktop: `~/Library/Application Support/Claude/claude_desktop_config.json`

Restart your AI tool after setup.

## Advanced Configuration (Optional)

For non-Cursor clients or users who want more project-level control, you can add these optional environment variables:

```json
{
  "mcpServers": {
    "xcf": {
      "command": "/path/to/xcf",
      "args": [],
      "env": {
        "WORKSPACE_FOLDER_PATHS": "/path/to/your/workspace/",
        "XCODE_PROJECT": "/path/to/your/project.xcodeproj"
      }
    }
  }
}
```

Note: Remove the "_optional" suffix from variable names in the actual config. These environment variables let you:
- Pre-select a specific Xcode project to work with
- Define a custom workspace boundary for security

## Commands

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

## MCP Tools

### Function-Based Tools
- `mcp_xcf_xcf`: Execute xcf actions/commands
- `mcp_xcf_list`: Show all available tools
- `mcp_xcf_snippet`: Access file contents
- `mcp_xcf_help`: Get help information

## Using Snippets

### For AI Function Calls

To get an entire file:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", entireFile=true)
```

For specific line ranges:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", startLine=10, endLine=20)
```

### For Human Commands

xcf now supports simplified, user-friendly snippet commands:

To get an entire file, just use the filename:
```
snippet filename.swift
```

No need for full paths or additional parameters - xcf will intelligently find and display the complete file contents.

For specific line ranges (still available but typically not needed):
```
snippet /full/path/to/file.swift 10 20
```

### Smart Path Resolution

When a file isn't found at the exact path, xcf will intelligently search for it in:

1. The current working directory
2. The workspace folder specified in the environment
3. Subdirectories (one level deep) in the workspace
4. The current project directory

This means you can usually just use the filename without any path:

```
snippet Constants.swift
```

The simplified syntax makes code exploration much faster and more intuitive during conversations with your AI assistant.

## Security Features

- Safely works with projects in your designated workspace
- Automatically prevents access outside your workspace boundaries
- Redirects to safe alternatives when needed
- Uses environment variables to define secure boundaries

## Workflow Examples

### Basic Workflow
1. `use xcf` - Activate the tool
2. `show` - See available projects
3. `open #` - Select a project 
4. `build` - Build the project
5. `run` - Run the project

## Troubleshooting

If commands fail, check:
- xcf installation is correct
- Configuration settings are valid
- Permissions are properly set
- Environment variables with `env`
- Try restarting your AI assistant
