// Define string constants for commands
struct Actions {
    static let xcf = AppConstants.appName
    static let help = "help"
    static let list = "list"
    static let select = "select"
    static let run = "run"
    static let build = "build"
    static let grant = "grant"
    static let useXcf = "use \(AppConstants.appName)"
    static let current = "current"
    static let env = "env"
}

// Define help text
static let helpText = """
\(AppConstants.appName) actions:
- use \(AppConstants.appName): Activate \(AppConstants.appName) mode
- grant: permission to use xcode automation
- list: [open xc projects and workspaces]
- select #: [open xc project or workspace]
- run: Execute the current \(AppConstants.appName) project
- build: Build the current \(AppConstants.appName) project
- current: Display the currently selected project
- env: Show all environment variables
- help: Show this help information
""" 