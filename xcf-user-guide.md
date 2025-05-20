# XCF Xcode MCP Server - Comprehensive User Guide 🚀

## 🌟 Introduction

XCF (Xcode MCP Server) is a powerful, Swift-native automation tool designed to revolutionize your Xcode development workflow. This guide provides an in-depth look at installation, configuration, and usage of XCF.

## 🔧 Installation & Setup

### System Requirements
- macOS (latest version recommended)
- Xcode installed
- Basic understanding of terminal and Swift development

### Installation Steps

1. **Download XCF**
   - Visit the official website or GitHub repository
   - Download the latest XCF application

2. **Install Application**
   - Drag the XCF.app to your `/Applications` folder
   - Launch the application once to approve internet downloads

3. **Codesign (if needed)**
   ```bash
   codesign --force --deep --sign - /Applications/xcf.app
   ```

### Configuration

#### MCP Server Configuration

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

##### Configuration Locations
- **Cursor**: `~/.cursor/mcp.json`
- **Claude Desktop**: `~/Library/Application Support/Claude/claude_desktop_config.json`

#### Advanced Configuration

For project-specific control:

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

## 🎬 Getting Started

### Activation

Activate XCF mode:
```
use_xcf
```

### Basic Workflow

1. List available projects
   ```
   show
   ```

2. Select a project
   ```
   open 1  # Opens the first project in the list
   ```

3. Build the project
   ```
   build
   ```

4. Run the project
   ```
   run
   ```

## 📂 File Operations

### Path Resolution and Quoting

XCF supports flexible path resolution:
- Current directory: `file.swift`
- Child directories: `src/file.swift`
- Parent directory: `../file.swift`
- Multiple directories up: `../../file.swift`
- Full system paths: `/Users/username/project/file.swift`

**Quoting Rules:**
- Use quotes for content with spaces
- Can use single `'` or double `"` quotes
- Recommended for complex content or paths with spaces

### Reading Files
```bash
read_file main.swift                   # Current directory
read_file src/utils.swift               # Child directory
read_file ../shared/config.swift        # Parent directory
read_file /full/path/to/main.swift      # Full path
```

### Writing Files
```bash
write_file test.txt "Hello World"      # Simple content
write_file config.json '{"key": "value"}'  # JSON content
write_file "../shared/types.swift" 'import Foundation'  # Quoted path
```

### Editing Files
```bash
edit_file main.swift 10 20 "Updated code"  # Replace lines 10-20
edit_file src/test.swift 5 5 "import UIKit"  # Replace single line
```

### File Management
```bash
delete_file temp.txt                   # Delete file
move_file old.swift new.swift           # Move/rename file
```

### Diff Operations

XCF provides powerful diff tools for comparing and applying changes to files and strings.

#### Basic Diff Operations
```bash
# Create a diff between two strings
create_diff "old text" "new text"

# Apply a diff to a source string
apply_diff "old text" "+new line\n-old line"
```

#### Document-Based Diff Operations
```bash
# Create a diff from an entire document
create_diff main.swift destString="updated content" entireFile=true

# Create a diff from specific lines
create_diff main.swift destString="updated content" startLine=10 endLine=20

# Apply a diff to a document
apply_diff main.swift destString="+new line\n-old line" startLine=10 endLine=20
```

#### Diff Operation Parameters
- `sourceString`: Original source string (optional)
- `destString`: Destination string or diff to apply
- `filePath`: Path to source document (optional)
- `startLine`: Start line for partial document diff (optional)
- `endLine`: End line for partial document diff (optional)
- `entireFile`: Use entire file for diff (optional, default: false)

#### Workflow Example
```bash
# Typical diff workflow
read_file main.swift                   # Read current file
create_diff main.swift destString="updated content"  # Generate diff
apply_diff main.swift destString="+new line\n-old line"  # Apply changes
build                                  # Rebuild project
```

#### Best Practices
1. Always review diffs before applying
2. Use line ranges for precise modifications
3. Backup files before applying large changes
4. Use `build` to verify changes don't break compilation

#### Diff Syntax
- `+`: Add a line
- `-`: Remove a line
- Lines without `+` or `-` remain unchanged

#### Error Handling
- Diffs that cannot be applied will return an error
- Partial diffs support line-specific modifications
- Use `entireFile=true` for complete document replacement

## 📁 Directory Operations

### Checking Current Directory
```
xcf pwd   # Show current working directory
cd_dir .  # Confirm or reset to current directory
```

### Changing Directories
```
cd_dir /path/to/project  # Change to specific directory
```

### Listing Contents
```
read_dir .  # Current directory
read_dir . swift  # Swift files only
```

### Directory Management
- Create: `add_dir new_folder`
- Remove: `rm_dir old_folder`
- Move: `move_dir source_dir destination_dir`

### Best Practices
1. Always check current directory before file operations
2. Use `xcf pwd` to verify your working context
3. Use `cd_dir .` to ensure you're in the expected directory

## 📄 Xcode Document Management

### Opening Documents
```bash
open_doc main.swift
```

### Creating Documents
```bash
create_doc new.swift "import Foundation"
```

### Editing Documents
```bash
edit_doc main.swift 10 20 "// New implementation"
```

### Document Lifecycle
- Read: `read_doc main.swift`
- Save: `save_doc main.swift`
- Close: `close_doc main.swift true  # With saving`

## 🔍 Code Analysis

### Snippet Extraction
```bash
snippet main.swift  # Entire file
snippet main.swift 10 20  # Specific lines
```

### Code Analysis
```bash
analyzer main.swift  # Full file analysis
lz main.swift  # Shorthand analysis
```

### Analysis Features
- Code style checks
- Complexity evaluation
- Unused variable detection
- Refactoring suggestions
- Method length analysis

## 🤖 AI Assistant Integration

### MCP Tools
- `mcp_xcf_xcf`: Execute actions
- `mcp_xcf_snippet`: Extract code
- `mcp_xcf_analyzer`: Code analysis
- `mcp_xcf_read_file`: Read files
- `mcp_xcf_write_file`: Write files

### Standalone Action Tools
XCF now provides direct tools for each action, making it easier to use and discover functionality:

| Tool | Description |
|------|-------------|
| `mcp_xcf_show_help` | Display help information about available commands |
| `mcp_xcf_grant_permission` | Grant Xcode automation permissions |
| `mcp_xcf_run_project` | Run the current Xcode project |
| `mcp_xcf_build_project` | Build the current Xcode project |
| `mcp_xcf_show_current_project` | Show information about the currently selected project |
| `mcp_xcf_show_env` | Display all environment variables |
| `mcp_xcf_show_folder` | Display the current working folder |
| `mcp_xcf_list_projects` | List all open Xcode projects |
| `mcp_xcf_select_project` | Select an Xcode project by number |
| `mcp_xcf_analyze_swift_code` | Analyze Swift code for potential issues |

### AI-Optimized Workflow Example
```@
# Basic workflow using standalone tools
mcp_xcf_use_xcf()               # Activate XCF
mcp_xcf_list_projects()         # List available projects
mcp_xcf_select_project(projectNumber=1)  # Select first project
mcp_xcf_build_project()         # Build the project
mcp_xcf_run_project()           # Run the project

# Code analysis using dedicated tools
mcp_xcf_show_current_project()  # Check current project
mcp_xcf_analyze_swift_code(filePath="main.swift")  # Analyze code
```@

## 🔒 Security & Best Practices

### Security Features
- Workspace-bound operations
- Automatic access prevention
- Environment variable security
- Safe action redirection

### Best Practices
1. Always activate XCF before operations
2. Use specific file paths
3. Leverage smart path resolution
4. Implement error handling
5. Analyze code before major changes

## 🚨 Troubleshooting

### Common Issues
- Verify Xcode installation
- Check XCF permissions
- Validate configuration
- Review environment variables

### Debugging Commands
```bash
env  # Show environment
pwd  # Current directory
help  # Available commands
```

## 🌐 Community & Support

- GitHub Repository: [XCF GitHub](https://github.com/codefreezeai/xcf)
- Website: [xcf.ai](https://xcf.ai)
- Community: Open to contributions!

## 📋 Version Information
- Check current version with `xcf version`
- Stay updated with latest releases

---

Created by XCodeFreeze Automation - Empowering Swift Developers Worldwide! 🚀 