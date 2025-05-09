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

## Basic Commands

Start with `use xcf` to activate. Then use:

- `show` - See open Xcode projects
- `open #` - Select project by number
- `build` - Build current project
- `run` - Run current project
- `current` - Show selected project
- `help` - See all commands

## MCP Tools

- `list` - Show available tools
- `snippet` - Get code from files
- `help` - Show commands

## Using Snippets

The AI can access your code with:

```
mcp_xcf_snippet(filePath="/path/to/file.swift", entireFile=true)
```

For specific lines:
```
mcp_xcf_snippet(filePath="/path/to/file.swift", startLine=10, endLine=20)
```

Quick access with @ shorthand:
```
mcp_xcf_snippet(filePath="@filename.swift", entireFile=true)
```

## Security

- Works safely with projects in your workspace 
- Smart enough to stay within your project boundaries
- No need to worry about access to external files
- Use `env` command to view your workspace boundaries
