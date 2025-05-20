# XCF - AI Assistant Integration Guide

## 🤖 Overview for AI Assistants

XCF (Xcode MCP Server) is a powerful Swift-based automation tool designed to streamline Xcode project management for AI assistants. This guide provides comprehensive instructions for integrating XCF into AI-powered development workflows.

## 🔧 Configuration

### MCP Server Setup

Add XCF to your MCP configuration file with the following JSON:

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

#### Configuration Locations
- **Cursor**: `~/.cursor/mcp.json`
- **Claude Desktop**: `~/Library/Application Support/Claude/claude_desktop_config.json`

### Advanced Project Configuration

For project-specific control, use environment variables:

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

## 🛠️ AI-Powered Workflow Tools

### MCP Function Tools

XCF provides a rich set of tools for AI assistants:

| Tool | Purpose | Example Usage |
|------|---------|---------------|
| `mcp_xcf_xcf` | Execute XCF actions | `mcp_xcf_xcf(action="build")` |
| `mcp_xcf_snippet` | Extract code snippets | `mcp_xcf_snippet(filePath="main.swift", entireFile=true)` |
| `mcp_xcf_analyzer` | Analyze Swift code | `mcp_xcf_analyzer(filePath="main.swift", entireFile=true)` |
| `mcp_xcf_read_file` | Read file contents | `mcp_xcf_read_file(filePath="main.swift")` |
| `mcp_xcf_write_file` | Write file contents | `mcp_xcf_write_file(filePath="test.txt", content="Hello World")` |

### Standalone Action Tools

In addition to the general-purpose tools, XCF now provides dedicated tools for each action:

| Tool | Purpose | Example Usage |
|------|---------|---------------|
| `mcp_xcf_show_help` | Display help information | `mcp_xcf_show_help()` |
| `mcp_xcf_grant_permission` | Grant Xcode permissions | `mcp_xcf_grant_permission()` |
| `mcp_xcf_run_project` | Run the current project | `mcp_xcf_run_project()` |
| `mcp_xcf_build_project` | Build the current project | `mcp_xcf_build_project()` |
| `mcp_xcf_show_current_project` | Show selected project | `mcp_xcf_show_current_project()` |
| `mcp_xcf_show_env` | Display environment variables | `mcp_xcf_show_env()` |
| `mcp_xcf_show_folder` | Show current directory | `mcp_xcf_show_folder()` |
| `mcp_xcf_list_projects` | List all Xcode projects | `mcp_xcf_list_projects()` |
| `mcp_xcf_select_project` | Select a project by number | `mcp_xcf_select_project(projectNumber=1)` |
| `mcp_xcf_analyze_swift_code` | Analyze Swift code | `mcp_xcf_analyze_swift_code(filePath="main.swift")` |

### Workflow Patterns

#### Basic Project Management

```
# Activate XCF
use_xcf

# List and select project
show
open 1

# Build and run
build
run
```

#### Code Analysis Workflow

```
# Activate XCF
use_xcf

# Get current project
current

# Extract and analyze code
snippet main.swift
analyzer main.swift

# Implement fixes
edit_file main.swift 10 20 "# Improved implementation"

# Rebuild
build
```

## 🔍 Smart Path Resolution

XCF uses intelligent path resolution for file operations:

1. Exact path provided
2. Relative path from current directory
3. Current project directory
4. Workspace folder
5. Recursive workspace search
6. Fuzzy filename matching

### File Access Examples

```python
# These are equivalent
mcp_xcf_snippet(filePath="/full/path/to/file.swift")
mcp_xcf_snippet(filePath="file.swift")  # Smart resolution
```

## 📊 Code Analysis Capabilities

The Swift code analyzer provides:
- Code style checks
- Complexity analysis
- Unused variable detection
- Magic number identification
- Refactoring suggestions
- Method length evaluation

### Analysis Example

```python
# Analyze entire file
mcp_xcf_analyzer(filePath="main.swift", entireFile=true)

# Analyze specific line range
mcp_xcf_analyzer(
    filePath="main.swift", 
    startLine=10, 
    endLine=50
)
```

## 🔒 Security Considerations

- Workspace-bound operations
- Automatic access prevention outside workspace
- Environment variable-based security
- Safe redirection of potentially unsafe actions

## 🚀 Performance Tips

- Use specific file paths when possible
- Leverage smart path resolution
- Utilize line-range analysis for large files
- Prefer MCP function tools for programmatic interactions

## 🤝 Integration Best Practices

1. Always activate XCF before operations
2. Use environment variables for project configuration
3. Leverage smart path resolution
4. Implement error handling
5. Use code analysis before major changes

## 📋 Comprehensive Tool List

Refer to the User Guide for a complete list of available tools and their detailed usage.

## 🎛️ XCF Core Actions

### Available Actions

| Action | Description | Example | Purpose |
|--------|-------------|---------|---------|
| `grant` | Grant Xcode automation permissions | `mcp_xcf_xcf(action="grant")` | Authorize XCF to interact with Xcode |
| `show` | List open projects | `mcp_xcf_xcf(action="show")` | Display available Xcode projects |
| `open #` | Select project by number | `mcp_xcf_xcf(action="open 1")` | Choose a specific project to work on |
| `current` | Show selected project | `mcp_xcf_xcf(action="current")` | Display the currently active project |
| `build` | Build current project | `mcp_xcf_xcf(action="build")` | Compile the selected Xcode project |
| `run` | Run current project | `mcp_xcf_xcf(action="run")` | Execute the current project |
| `env` | Show environment variables | `mcp_xcf_xcf(action="env")` | Display system environment configuration |
| `pwd` | Show current folder | `mcp_xcf_xcf(action="pwd")` | Display current working directory |
| `analyze` | Analyze Swift code | `mcp_xcf_xcf(action="analyze main.swift")` | Perform code analysis on a file |
| `lz` | Shorthand for analyze | `mcp_xcf_xcf(action="lz main.swift")` | Quick code analysis |

### Comprehensive Workflow Example

```
# Full project lifecycle management
mcp_xcf_xcf(action="grant")  # Authorize XCF
mcp_xcf_xcf(action="show")   # List projects
mcp_xcf_xcf(action="open 1") # Select first project
mcp_xcf_xcf(action="current") # Confirm project
mcp_xcf_xcf(action="build")   # Build project
mcp_xcf_xcf(action="run")     # Run project

# Code analysis workflow
mcp_xcf_xcf(action="analyze main.swift")  # Detailed analysis
mcp_xcf_xcf(action="lz main.swift")       # Quick analysis
```

### Environment and Context Management

```python
# Check environment and context
mcp_xcf_xcf(action="env")    # Show environment variables
mcp_xcf_xcf(action="pwd")    # Show current working directory
```

### Aliases and Shortcuts

Some commands have convenient aliases:
- `pwd` can also use `dir` or `path`
- `lz` is a quick shorthand for `analyze`

## 🔍 Smart Action Resolution

XCF intelligently handles actions by:
- Automatically selecting the most recent project
- Providing fallback mechanisms
- Offering clear, actionable feedback
- Supporting relative and absolute paths

---

**Pro Tip:** Always use `grant` first to ensure full XCF functionality!

---

Created by XCodeFreeze Automation - Empowering AI-driven Swift development! 