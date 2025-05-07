# xcf
XCodeFreeze MCP Xcode Automation local server

## Get Started
Add an `xcf` entry to the `mcpServers` block of `~/.cursor/mcp.json` for Cursor, or `~/Library/Application Support/Claude/claude_desktop_config.json` for Claude Desktop for macOS.

Like this:
```json
{
  "mcpServers": {
    "xcf": {
      "type": "stdio",
      "command": "/Users/username/pathto/xcf"
    }
  }
}
```

Restart Cursor or Claude.
Tell it to use xcf to work on your Xcode project.
