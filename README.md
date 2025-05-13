# 🚀 XCF Xcode MCP Server
## The Swift way to Super Charge your AI Workflow!

[![XCF Website](https://img.shields.io/badge/Website-xcf.ai-blue)](https://xcf.ai) [![Pure Swift](https://img.shields.io/badge/100%25-Swift-orange)](https://github.com/codefreezeai/xcf)

Speed up writing Xcode apps with xcf, a dead simple Swift-based MCP server specifically designed for Cursor. Works seamlessly with VSCode and Claude, with no TypeScript, no JavaScript, no BS!

## 🧰 Installation

## XCF Installation & Configuration

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
      "command": "/Applications/xcf.app/Contents/MacOS/xcf server"
    }
  }
}
```

### Configuration Locations
- **Cursor**: `~/.cursor/mcp.json`
- **Claude Desktop**: `~/Library/Application Support/Claude/claude_desktop_config.json`

⚠️ **Important:** Restart your AI assistant after setup or refresh the tool.

## ⚙️ Advanced Configuration

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
- Pre-select a specific Xcode project to work with
- Define a custom workspace boundary for security

## ✨ Key Features

- **Zero Dependencies:** Easy to install, no reliance on other MCP servers
- **Automatic Project Detection:** Auto-selects your Xcode project so you can start coding immediately
- **Real-time Error Handling:** `xcf build` or `xcf run` sends errors and warnings from Xcode directly to your AI IDE
- **AI-Powered Fixes:** Let Claude fix bugs and mistakes during your coding sessions
- **Intuitive Commands:** Simple, developer-friendly command structure for maximum productivity

## 🛠️ Perfect for Swift Developers

The tool is designed by Swift developers, for Swift developers. Commands like `build`, `run`, and `show` make the workflow intuitive and natural.

## 📋 Commands Reference

| Command | Description |
|---------|-------------|
| `use xcf` | Activate xcf mode |
| `show` | List open Xcode projects |
| `open #` | Select project by number |
| `run` | Run current project |
| `build` | Build current project |
| `current` | Show selected project |
| `env` | Show environment variables |
| `pwd` | Show current folder (aliases: dir, path) |
| `help` | Display all available commands |

## 📄 Using Snippets

### For Human Commands

xcf supports simplified, user-friendly snippet commands:

To get an entire file, just use the filename:
```
snippet filename.swift
```

No need for full paths or additional parameters - xcf will intelligently find and display the complete file contents.

For specific line ranges:
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

## 🧩 MCP Tools

### Function-Based Tools
- `mcp_xcf_xcf`: Execute xcf actions/commands
- `mcp_xcf_list`: Show all available tools
- `mcp_xcf_snippet`: Access file contents
- `mcp_xcf_help`: Get help information

### For AI Function Calls

To get an entire file:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", entireFile=true)
```

For specific line ranges:
```
mcp_xcf_snippet(filePath="/full/path/to/file.swift", startLine=10, endLine=20)
```

## 🔒 Security Features

- Safely works with projects in your designated workspace
- Automatically prevents access outside your workspace boundaries
- Redirects to safe alternatives when needed
- Uses environment variables to define secure boundaries

## 🔄 Workflow Examples

### Basic Workflow
1. `use xcf` - Activate the tool
2. `show` - See available projects
3. `open #` - Select a project 
4. `build` - Build the project
5. `run` - Run the project

## 📺 Demo

Watch XCF in action: [YouTube Demo](https://www.youtube.com/embed/7KfrsZfQIIg)

## ❓ Troubleshooting

If commands fail, check:
- xcf installation is correct
- Refreshing xcf MCP Server
- Configuration settings are valid
- Permissions are properly set
- Environment variables with `env`
- Try restarting your AI assistant

## 🤝 Open Source Community

Swift Engineers are welcome to contribute! Help us make xcf even better.

## 💯 Pure Swift, Purely Open

100% Swift. 100% Open Source.  
[GitHub Repository](https://github.com/codefreezeai/xcf)

---

Created by XCodeFreeze Automation and CodeFreeze.ai - Bringing the future of Swift development to your fingertips!
