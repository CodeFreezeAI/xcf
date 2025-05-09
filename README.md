# XCF : XCodeFreeze : Xcode Automation with MCP and AI
- xcf MCP Server written in Swift
- uses stdio
- easy to use and install
- To compile requires Xcode 16, compiled releases are coming soon!
- Apps can be in older version of Xcode as long as your OS supports it

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

## Usage

Once the xcf MCP server is configured, you can use it in your AI assistant by typing:

```
use xcf
```

This activates the xcf mode, which allows you to work with Xcode projects directly from your AI assistant.

### Available Commands

After activating xcf with the `use xcf` command, you can use the following commands:

- `grant` - Grant permission to use Xcode automation
- `list` - Show open Xcode projects and workspaces
- `select #` - Open an Xcode project or workspace by number
- `run` - Execute the currently selected Xcode project
- `build` - Build the currently selected Xcode project
- `current` - Display the currently selected project
- `env` - Show all environment variables
- `help` - Show help information

### MCP Tool Commands

When using xcf through MCP in an AI assistant, you can also use these special commands:

- `list` - Lists all available MCP tools provided by xcf
- `snippet` - Extract code snippets from files in the project
- `help` - Displays detailed help about xcf actions and usage

Example output of `list`:

```
Available tools:
- xcf: Execute an xcf action or command
- list: Lists all available tools on this server
- snippet: Extract code snippets from files in the current project (use entireFile=true to get full file content)
- help: Displays help information about xcf actions and usage
```

#### Using the Snippet Tool

The snippet tool allows the AI to access and analyze code files. When used by the AI assistant, it can:

1. Get an entire file:
   ```
   mcp_XCodeFreeze_snippet(filePath="/path/to/your/file.swift", entireFile=true)
   ```

2. Get a specific line range:
   ```
   mcp_XCodeFreeze_snippet(filePath="/path/to/your/file.swift", startLine=10, endLine=20)
   ```

This enables the AI to analyze specific parts of your codebase without needing to see the entire project.

### Example Workflow

1. Start by activating xcf: `use xcf`
2. Show open Xcode projects: `list`
3. Select a project: `select 1`
4. Build the selected project: `build`
5. Run the selected project: `run`

The AI can now interact with your Xcode project for automation tasks.

## Security Features

### Workspace Protection

When using xcf with Cursor, a security feature automatically restricts project selection to the current workspace directory. This protection mechanism uses the `WORKSPACE_FOLDER_PATHS` environment variable to determine which projects are safe to access.

Despite its plural name, `WORKSPACE_FOLDER_PATHS` currently represents a single workspace path. Users can manually set this environment variable, but it can only contain one workspace folder path at a time.

> **Note:** The `WORKSPACE_FOLDER_PATHS` environment variable is specific to Cursor and is not used by standard VS Code. This is a Cursor-specific security enhancement that prevents access to projects outside your authorized workspace.

If you attempt to select a project outside your current workspace, you'll see a message like:

```
Security measures prevent manual selection this project.
Current folder: /path/to/your/workspace
System override: /path/to/your/workspace/project.xcodeproj
```

The system will automatically select the project within your current workspace instead. This prevents potentially malicious actions and ensures your AI assistant only works with authorized projects.

You can verify your current workspace path with the `env` command, which shows all environment variables including `WORKSPACE_FOLDER_PATHS`.
