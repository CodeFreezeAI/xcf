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