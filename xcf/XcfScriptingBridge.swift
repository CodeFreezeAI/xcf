//
//  XcfScriptingBridge.swift
//  xcf
//
//  Created by Todd Bruss on 5/7/25.
//

import AppKit
import ScriptingBridge
import Foundation

/// # Xcode Scripting Bridge Interface
///
/// This file defines the protocol interfaces needed to interact with Xcode via the ScriptingBridge framework.
/// These interfaces allow Swift code to communicate with Xcode programmatically, enabling automation of
/// various Xcode operations like building, running, and manipulating projects and workspaces.
///
/// ## Usage Example:
/// ```swift
/// // Connect to Xcode
/// guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: "com.apple.dt.Xcode") else {
///     print("Failed to connect to Xcode")
///     return
/// }
///
/// // Open a project
/// let projectPath = "/path/to/your/project.xcodeproj"
/// if let workspace = xcode.open?(projectPath as Any) as? XcodeWorkspaceDocument {
///     // Build the project
///     let buildResult = workspace.build?()
///     
///     // Wait for build to complete
///     while !(buildResult?.completed ?? false) {
///         Thread.sleep(forTimeInterval: 0.5)
///     }
///     
///     // Check build status
///     if buildResult?.status == XcodeSchemeActionResultStatus.succeeded {
///         print("Build succeeded")
///     } else {
///         print("Build failed")
///     }
/// }
/// ```

/// Protocol that all ScriptingBridge objects must conform to
/// Provides basic functionality for retrieving values from AppleScript objects
@objc public protocol SBObjectProtocol: NSObjectProtocol {
    /// Gets the underlying AppleScript value
    /// - Returns: The value from the AppleScript object, or nil if not available
    func get() -> Any!
}

/// Protocol that all ScriptingBridge applications must conform to
/// Provides basic functionality for interacting with applications
@objc public protocol SBApplicationProtocol: SBObjectProtocol {
    /// Brings the application to the foreground
    func activate()
    
    /// The application's delegate for handling application events
    var delegate: SBApplicationDelegate! { get set }
    
    /// Indicates whether the application is currently running
    /// - Returns: true if the application is running, false otherwise
    var isRunning: Bool { get }
}

// MARK: - Enumerations

/// Options for saving documents when closing
/// Used when closing documents or quitting Xcode
@objc public enum XcodeSaveOptions : AEKeyword {
    /// Save changes before closing
    case yes = 0x79657320 /* b'yes ' */
    
    /// Discard changes before closing
    case no = 0x6e6f2020 /* b'no  ' */
    
    /// Prompt the user to decide whether to save changes
    case ask = 0x61736b20 /* b'ask ' */
}

/// Status values for scheme action results
/// Indicates the current state of build, run, or test operations
@objc public enum XcodeSchemeActionResultStatus : AEKeyword {
    /// The action has not yet started
    case notYetStarted = 0x7372736e /* b'srsn' */
    
    /// The action is currently running
    case running = 0x73727372 /* b'srsr' */
    
    /// The action was cancelled by the user
    case cancelled = 0x73727363 /* b'srsc' */
    
    /// The action failed to complete successfully
    case failed = 0x73727366 /* b'srsf' */
    
    /// An error occurred during the action
    case errorOccurred = 0x73727365 /* b'srse' */
    
    /// The action completed successfully
    case succeeded = 0x73727373 /* b'srss' */
}

// MARK: - Generic Methods

/// Common methods available across multiple Xcode objects
/// These methods provide basic functionality for manipulating Xcode items
@objc public protocol XcodeGenericMethods {
    /// Closes a document with options for saving changes
    /// - Parameters:
    ///   - saving: How to handle unsaved changes (yes, no, or ask)
    ///   - savingIn: Location to save the document if needed
    @objc optional func closeSaving(_ saving: XcodeSaveOptions, savingIn: URL!)
    
    /// Deletes an object
    @objc optional func delete()
    
    /// Moves an object to a new location
    /// - Parameter to: The destination object
    @objc optional func moveTo(_ to: SBObject!)
    
    /// Builds the current scheme
    /// - Returns: A result object that can be used to track build progress
    @objc optional func build() -> XcodeSchemeActionResult
    
    /// Cleans the current build
    /// - Returns: A result object that can be used to track clean progress
    @objc optional func clean() -> XcodeSchemeActionResult
    
    /// Stops the currently running scheme action
    @objc optional func stop()
    
    /// Runs the current scheme with optional arguments and environment variables
    /// - Parameters:
    ///   - withCommandLineArguments: Command-line arguments to pass to the app
    ///   - withEnvironmentVariables: Environment variables to set for the app
    /// - Returns: A result object that can be used to track run progress
    @objc optional func runWithCommandLineArguments(_ withCommandLineArguments: Any!, withEnvironmentVariables: Any!) -> XcodeSchemeActionResult
    
    /// Runs tests for the current scheme with optional arguments and environment variables
    /// - Parameters:
    ///   - withCommandLineArguments: Command-line arguments to pass to the tests
    ///   - withEnvironmentVariables: Environment variables to set for the tests
    /// - Returns: A result object that can be used to track test progress
    @objc optional func testWithCommandLineArguments(_ withCommandLineArguments: Any!, withEnvironmentVariables: Any!) -> XcodeSchemeActionResult
    
    /// Attaches the debugger to a running process
    /// - Parameters:
    ///   - toProcessIdentifier: PID of the process to attach to
    ///   - suspended: Whether to suspend the process when attaching
    @objc optional func attachToProcessIdentifier(_ toProcessIdentifier: Int, suspended: Bool)
    
    /// Starts debugging a scheme
    /// - Parameters:
    ///   - scheme: Name of the scheme to debug (nil for active scheme)
    ///   - runDestinationSpecifier: Run destination to use (nil for active destination)
    ///   - skipBuilding: Whether to skip building before debugging
    ///   - commandLineArguments: Command-line arguments to pass to the app
    ///   - environmentVariables: Environment variables to set for the app
    /// - Returns: A result object that can be used to track debug progress
    @objc optional func debugScheme(_ scheme: String!, runDestinationSpecifier: String!, skipBuilding: Bool, commandLineArguments: Any!, environmentVariables: Any!) -> XcodeSchemeActionResult
}

// MARK: - XcodeApplication

/// Protocol representing the Xcode application itself
/// This is the main entry point for scripting Xcode
@objc public protocol XcodeApplication: SBApplicationProtocol {
    /// Returns all documents open in Xcode
    @objc optional func documents() -> SBElementArray
    
    /// Returns all windows open in Xcode
    @objc optional func windows() -> SBElementArray
    
    /// The name of the application
    @objc optional var name: String { get }
    
    /// Whether Xcode is the frontmost application
    @objc optional var frontmost: Bool { get }
    
    /// The version number of Xcode
    @objc optional var version: String { get }
    
    /// Opens a document
    /// - Parameter x: Path to the document or URL object
    /// - Returns: The opened document object
    @objc optional func `open`(_ x: Any!) -> Any
    
    /// Quits Xcode with options for saving changes
    /// - Parameter saving: How to handle unsaved changes (yes, no, or ask)
    @objc optional func quitSaving(_ saving: XcodeSaveOptions)
    
    /// Checks if an object exists
    /// - Parameter x: The object to check
    /// - Returns: true if the object exists, false otherwise
    @objc optional func exists(_ x: Any!) -> Bool
    
    /// Creates a temporary workspace for debugging
    /// - Returns: The created workspace document
    @objc optional func createTemporaryDebuggingWorkspace() -> XcodeWorkspaceDocument
    
    /// Returns all file documents open in Xcode
    @objc optional func fileDocuments() -> SBElementArray
    
    /// Returns all source code documents open in Xcode
    @objc optional func sourceDocuments() -> SBElementArray
    
    /// Returns all workspace documents open in Xcode
    @objc optional func workspaceDocuments() -> SBElementArray
    
    /// The currently active workspace document
    @objc optional var activeWorkspaceDocument: XcodeWorkspaceDocument { get }
    
    /// Sets the active workspace document
    /// - Parameter activeWorkspaceDocument: The workspace document to make active
    @objc optional func setActiveWorkspaceDocument(_ activeWorkspaceDocument: XcodeWorkspaceDocument!)
}
extension SBApplication: XcodeApplication {}

/// Use the XcodeApplication protocol to interact with Xcode
/// Example:
/// ```swift
/// func getXcodeDocumentPaths(ext: String) -> [String] {
///     // Get Xcode application instance
///     guard let xcode: XcodeApplication = SBApplication(bundleIdentifier: "com.apple.dt.Xcode") else {
///         print("Failed to connect to Xcode")
///         return []
///     }
///     
///     // Get all documents
///     guard let documents = xcode.documents?() else {
///         return []
///     }
///     
///     var paths: [String] = []
///     
///     // Iterate through all documents and filter by extension
///     for case let document as XcodeDocument in documents {
///         if let name = document.name, name.contains(ext), let path = document.path {
///             paths.append(path)
///         }
///     }
///     
///     return paths
/// }
/// ```

// MARK: XcodeDocument
@objc public protocol XcodeDocument: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // Its name.
    @objc optional var modified: Bool { get } // Has it been modified since the last save?
    @objc optional var file: URL { get } // Its location on disk, if it has one.
    @objc optional var path: String { get } // The document's path.
    @objc optional func setPath(_ path: String!) // The document's path.
}
extension SBObject: XcodeDocument {}

// MARK: XcodeWindow
@objc public protocol XcodeWindow: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func id() -> Int // The unique identifier of the window.
    @objc optional var index: Int { get } // The index of the window, ordered front to back.
    @objc optional var bounds: NSRect { get } // The bounding rectangle of the window.
    @objc optional var closeable: Bool { get } // Does the window have a close button?
    @objc optional var miniaturizable: Bool { get } // Does the window have a minimize button?
    @objc optional var miniaturized: Bool { get } // Is the window minimized right now?
    @objc optional var resizable: Bool { get } // Can the window be resized?
    @objc optional var visible: Bool { get } // Is the window visible right now?
    @objc optional var zoomable: Bool { get } // Does the window have a zoom button?
    @objc optional var zoomed: Bool { get } // Is the window zoomed right now?
    @objc optional var document: XcodeDocument { get } // The document whose contents are displayed in the window.
    @objc optional func setIndex(_ index: Int) // The index of the window, ordered front to back.
    @objc optional func setBounds(_ bounds: NSRect) // The bounding rectangle of the window.
    @objc optional func setMiniaturized(_ miniaturized: Bool) // Is the window minimized right now?
    @objc optional func setVisible(_ visible: Bool) // Is the window visible right now?
    @objc optional func setZoomed(_ zoomed: Bool) // Is the window zoomed right now?
}
extension SBObject: XcodeWindow {}

// MARK: XcodeFileDocument
@objc public protocol XcodeFileDocument: XcodeDocument {
}
extension SBObject: XcodeFileDocument {}

// MARK: XcodeTextDocument
@objc public protocol XcodeTextDocument: XcodeFileDocument {
    @objc optional var selectedCharacterRange: [NSNumber] { get } // The first and last character positions in the selection.
    @objc optional var selectedParagraphRange: [NSNumber] { get } // The first and last paragraph positions that contain the selection.
    @objc optional var text: String { get } // The text of the text file referenced.
    @objc optional var notifiesWhenClosing: Bool { get } // Should Xcode notify other apps when this document is closed?
    @objc optional func setSelectedCharacterRange(_ selectedCharacterRange: [NSNumber]!) // The first and last character positions in the selection.
    @objc optional func setSelectedParagraphRange(_ selectedParagraphRange: [NSNumber]!) // The first and last paragraph positions that contain the selection.
    @objc optional func setText(_ text: String!) // The text of the text file referenced.
    @objc optional func setNotifiesWhenClosing(_ notifiesWhenClosing: Bool) // Should Xcode notify other apps when this document is closed?
}
extension SBObject: XcodeTextDocument {}

// MARK: XcodeSourceDocument
@objc public protocol XcodeSourceDocument: XcodeTextDocument {
}
extension SBObject: XcodeSourceDocument {}

// MARK: XcodeWorkspaceDocument
@objc public protocol XcodeWorkspaceDocument: XcodeDocument {
    @objc optional func projects() -> SBElementArray
    @objc optional func schemes() -> SBElementArray
    @objc optional func runDestinations() -> SBElementArray
    @objc optional var loaded: Bool { get } // Whether the workspace document has finsished loading after being opened. Messages sent to a workspace document before it has loaded will result in errors.
    @objc optional var activeScheme: XcodeScheme { get } // The workspace's scheme that will be used for scheme actions.
    @objc optional var activeRunDestination: XcodeRunDestination { get } // The workspace's run destination that will be used for scheme actions.
    @objc optional var lastSchemeActionResult: XcodeSchemeActionResult { get } // The scheme action result for the last scheme action command issued to the workspace document.
    @objc optional var file: URL { get } // The workspace document's location on disk, if it has one.
    @objc optional func setLoaded(_ loaded: Bool) // Whether the workspace document has finsished loading after being opened. Messages sent to a workspace document before it has loaded will result in errors.
    @objc optional func setActiveScheme(_ activeScheme: XcodeScheme!) // The workspace's scheme that will be used for scheme actions.
    @objc optional func setActiveRunDestination(_ activeRunDestination: XcodeRunDestination!) // The workspace's run destination that will be used for scheme actions.
    @objc optional func setLastSchemeActionResult(_ lastSchemeActionResult: XcodeSchemeActionResult!) // The scheme action result for the last scheme action command issued to the workspace document.
}
extension SBObject: XcodeWorkspaceDocument {}

// MARK: XcodeSchemeActionResult
@objc public protocol XcodeSchemeActionResult: SBObjectProtocol, XcodeGenericMethods {
    @objc optional func buildErrors() -> SBElementArray
    @objc optional func buildWarnings() -> SBElementArray
    @objc optional func analyzerIssues() -> SBElementArray
    @objc optional func testFailures() -> SBElementArray
    @objc optional func id() -> String // The unique identifier for the scheme.
    @objc optional var completed: Bool { get } // Whether this scheme action has completed (sucessfully or otherwise) or not.
    @objc optional var status: XcodeSchemeActionResultStatus { get } // Indicates the status of the scheme action.
    @objc optional var errorMessage: String { get } // If the result's status is "error occurred", this will be the error message; otherwise, this will be "missing value".
    @objc optional var buildLog: String { get } // If this scheme action performed a build, this will be the text of the build log.
    @objc optional func setStatus(_ status: XcodeSchemeActionResultStatus) // Indicates the status of the scheme action.
    @objc optional func setErrorMessage(_ errorMessage: String!) // If the result's status is "error occurred", this will be the error message; otherwise, this will be "missing value".
    @objc optional func setBuildLog(_ buildLog: String!) // If this scheme action performed a build, this will be the text of the build log.
}
extension SBObject: XcodeSchemeActionResult {}

// MARK: XcodeSchemeActionIssue
@objc public protocol XcodeSchemeActionIssue: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var message: String { get } // The text of the issue.
    @objc optional var filePath: String { get } // The file path where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional var startingLineNumber: Int { get } // The starting line number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional var endingLineNumber: Int { get } // The ending line number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional var startingColumnNumber: Int { get } // The starting column number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional var endingColumnNumber: Int { get } // The ending column number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional func setMessage(_ message: String!) // The text of the issue.
    @objc optional func setFilePath(_ filePath: String!) // The file path where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional func setStartingLineNumber(_ startingLineNumber: Int) // The starting line number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional func setEndingLineNumber(_ endingLineNumber: Int) // The ending line number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional func setStartingColumnNumber(_ startingColumnNumber: Int) // The starting column number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
    @objc optional func setEndingColumnNumber(_ endingColumnNumber: Int) // The ending column number in the file where the issue occurred. This may be 'missing value' if the issue is not associated with a specific source file.
}
extension SBObject: XcodeSchemeActionIssue {}

// MARK: XcodeBuildError
@objc public protocol XcodeBuildError: XcodeSchemeActionIssue {
}
extension SBObject: XcodeBuildError {}

// MARK: XcodeBuildWarning
@objc public protocol XcodeBuildWarning: XcodeSchemeActionIssue {
}
extension SBObject: XcodeBuildWarning {}

// MARK: XcodeAnalyzerIssue
@objc public protocol XcodeAnalyzerIssue: XcodeSchemeActionIssue {
}
extension SBObject: XcodeAnalyzerIssue {}

// MARK: XcodeTestFailure
@objc public protocol XcodeTestFailure: XcodeSchemeActionIssue {
}
extension SBObject: XcodeTestFailure {}

// MARK: XcodeScheme
@objc public protocol XcodeScheme: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // The name of the scheme.
    @objc optional func id() -> String // The unique identifier for the scheme.
}
extension SBObject: XcodeScheme {}

// MARK: XcodeRunDestination
@objc public protocol XcodeRunDestination: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // The name of the run destination, as displayed in Xcode's interface.
    @objc optional var architecture: String { get } // The architecture for which this run destination results in execution.
    @objc optional var platform: String { get } // The identifier of the platform which this run destination targets, such as "macosx", "iphoneos", "iphonesimulator", etc .
    @objc optional var device: XcodeDevice { get } // The physical or virtual device which this run destination targets.
    @objc optional var companionDevice: XcodeDevice { get } // If the run destination's device has a companion (e.g. a paired watch for a phone) which it will use, this is that device.
}
extension SBObject: XcodeRunDestination {}

// MARK: XcodeDevice
@objc public protocol XcodeDevice: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // The name of the device.
    @objc optional var deviceIdentifier: String { get } // A stable identifier for the device, as shown in Xcode's "Devices" window.
    @objc optional var operatingSystemVersion: String { get } // The version of the operating system installed on the device which this run destination targets.
    @objc optional var deviceModel: String { get } // The model of device (e.g. "iPad Air") which this run destination targets.
    @objc optional var generic: Bool { get } // Whether this run destination is generic instead of representing a specific device. Most destinations are not generic, but a generic destination (such as "Any iOS Device") will be available for some platforms if no physical devices are connected.
}
extension SBObject: XcodeDevice {}

// MARK: XcodeBuildConfiguration
@objc public protocol XcodeBuildConfiguration: SBObjectProtocol, XcodeGenericMethods {
    @objc optional func buildSettings() -> SBElementArray
    @objc optional func resolvedBuildSettings() -> SBElementArray
    @objc optional func id() -> String // The unique identifier for the build configuration.
    @objc optional var name: String { get } // The name of the build configuration.
}
extension SBObject: XcodeBuildConfiguration {}

// MARK: XcodeProject
@objc public protocol XcodeProject: SBObjectProtocol, XcodeGenericMethods {
    @objc optional func buildConfigurations() -> SBElementArray
    @objc optional func targets() -> SBElementArray
    @objc optional var name: String { get } // The name of the project
    @objc optional func id() -> String // The unique identifier for the project.
}
extension SBObject: XcodeProject {}

// MARK: XcodeBuildSetting
@objc public protocol XcodeBuildSetting: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // The unlocalized build setting name (e.g. DSTROOT).
    @objc optional var value: String { get } // A string value for the build setting.
    @objc optional func setName(_ name: String!) // The unlocalized build setting name (e.g. DSTROOT).
    @objc optional func setValue(_ value: String!) // A string value for the build setting.
}
extension SBObject: XcodeBuildSetting {}

// MARK: XcodeResolvedBuildSetting
@objc public protocol XcodeResolvedBuildSetting: SBObjectProtocol, XcodeGenericMethods {
    @objc optional var name: String { get } // The unlocalized build setting name (e.g. DSTROOT).
    @objc optional var value: String { get } // A string value for the build setting.
    @objc optional func setName(_ name: String!) // The unlocalized build setting name (e.g. DSTROOT).
    @objc optional func setValue(_ value: String!) // A string value for the build setting.
}
extension SBObject: XcodeResolvedBuildSetting {}

// MARK: XcodeTarget
@objc public protocol XcodeTarget: SBObjectProtocol, XcodeGenericMethods {
    @objc optional func buildConfigurations() -> SBElementArray
    @objc optional var name: String { get } // The name of this target.
    @objc optional func id() -> String // The unique identifier for the target.
    @objc optional var project: XcodeProject { get } // The project that contains this target
    @objc optional func setName(_ name: String!) // The name of this target.
}
extension SBObject: XcodeTarget {}
