//
//  XcfSwiftAnalyzer.swift
//  xcf
//
//  Created by Todd Bruss on 5/9/25.
//

import Foundation
import xcf_swift

/// Represents a check group for Swift code analysis
enum CheckGroup: String, CaseIterable {
    case all = "all"
    case syntax = "syntax"
    case style = "style"
    case safety = "safety"
    case performance = "performance"
    case bestPractices = "bestPractices"
    
    /// Get all individual checks for this group
    var checks: [IndividualCheck] {
        switch self {
        case .all:
            return IndividualCheck.allCases
        case .syntax:
            return [.swiftSyntax, .operatorPrecedence, .macroUsage]
        case .style:
            return [.codeStyle, .namingConventions]
        case .safety:
            return [.forceUnwraps, .immutableAssignments, .emptyCatchBlocks, .optionalChainingDepth]
        case .performance:
            return [.cycloComplexity, .longMethods, .unreachableCode]
        case .bestPractices:
            return [.unusedVariables, .guardUsage, .refactoringOpportunities]
        }
    }
}

/// Represents an individual check for Swift code analysis
enum IndividualCheck: String, CaseIterable {
    case swiftSyntax = "syntax"
    case unusedVariables = "unusedVars"
    case immutableAssignments = "immutables"
    case unreachableCode = "unreachable"
    case forceUnwraps = "forcedUnwraps"
    case operatorPrecedence = "operators"
    case codeStyle = "style"
    case refactoringOpportunities = "refactor"
    case symbolUsage = "symbols"
    case macroUsage = "macros"
    case cycloComplexity = "complexity"
    case guardUsage = "guards"
    case longMethods = "longMethods"
    case emptyCatchBlocks = "emptyCatch"
    case optionalChainingDepth = "optionalChain"
    case namingConventions = "naming"
}

/// A class that handles Swift code analysis using the Swift Code Checker
struct SwiftAnalyzer {
    /// Analyzes a Swift file using the Swift Code Checker and returns the analysis results
    /// - Parameters:
    ///   - filePath: The path to the Swift file to analyze
    ///   - entireFile: Whether to analyze the entire file or a specific line range
    ///   - startLine: If not analyzing the entire file, the starting line to analyze
    ///   - endLine: If not analyzing the entire file, the ending line to analyze
    ///   - checkGroups: The check groups to run (defaults to all)
    ///   - individualChecks: Individual checks to run (overrides check groups if specified)
    ///   - format: The output format (markdown or text)
    /// - Returns: A tuple containing the analysis results and the language of the file
    static func analyzeCode(
        filePath: String,
        entireFile: Bool = true,
        startLine: Int? = nil,
        endLine: Int? = nil,
        checkGroups: [CheckGroup] = [.all],
        individualChecks: [IndividualCheck] = [],
        format: String = "markdown"
    ) -> (String, String) {
        // First resolve the file path using multiple strategies
        let (resolvedPath, warning) = FileFinder.resolveFilePath(filePath)
        
        // If we got a warning about duplicate files, prepare it
        var warningMessage = ""
        if !warning.isEmpty {
            warningMessage = warning + Format.newLine + Format.newLine
        }
        
        // Determine the language of the file
        let language = FileFinder.determineLanguage(from: resolvedPath)
        
        // If the file is not a Swift file, return an error message
        guard language == "swift" else {
            return (warningMessage + "Can only analyze Swift files, but found a file of type: \(language)", language)
        }
        
        // Validate file path - use the resolved path
        guard FileManager.default.fileExists(atPath: resolvedPath) else {
            return (warningMessage + String(format: ErrorMessages.errorReadingFile, "File not found. Tried searching for \(filePath) in multiple locations."), language)
        }
        
        // Determine which checks to run
        let checksToRun = individualChecks.isEmpty ? 
            checkGroups.flatMap { $0.checks } : individualChecks
        
        // If we're analyzing the entire file, use the full file analysis
        if entireFile {
            return analyzeEntireFile(
                filePath: resolvedPath,
                checksToRun: checksToRun,
                format: format,
                warning: warningMessage
            )
        } else {
            // Otherwise, analyze a specific line range
            guard let startLine = startLine, let endLine = endLine else {
                return (warningMessage + "Missing line range for analysis. Please specify both --startLine and --endLine.", language)
            }
            
            return analyzeFileLineRange(
                filePath: resolvedPath,
                startLine: startLine,
                endLine: endLine,
                checksToRun: checksToRun,
                format: format,
                warning: warningMessage
            )
        }
    }
    
    /// Analyzes an entire Swift file using the Swift Code Checker
    /// - Parameters:
    ///   - filePath: The path to the Swift file to analyze
    ///   - checksToRun: The individual checks to run
    ///   - format: The output format (markdown or text)
    ///   - warning: Any warning message to include with the results
    /// - Returns: A tuple containing the analysis results and the language of the file
    private static func analyzeEntireFile(
        filePath: String,
        checksToRun: [IndividualCheck],
        format: String,
        warning: String = ""
    ) -> (String, String) {
        do {
            // Use the SwiftCodeChecker from the xcf-swift library
            let checker = SwiftCodeChecker()
            var allIssues: [SourceKitIssue] = []
            
            // Run specific checks or all checks
            if checksToRun.isEmpty || checksToRun.contains(.swiftSyntax) {
                allIssues.append(contentsOf: try runCheck(checker.checkSwiftSyntax, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.unusedVariables) {
                allIssues.append(contentsOf: try runCheck(checker.checkUnusedVariables, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.immutableAssignments) {
                allIssues.append(contentsOf: try runCheck(checker.checkImmutableAssignments, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.unreachableCode) {
                allIssues.append(contentsOf: try runCheck(checker.checkUnreachableCode, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.forceUnwraps) {
                allIssues.append(contentsOf: try runCheck(checker.checkForceUnwraps, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.operatorPrecedence) {
                allIssues.append(contentsOf: try runCheck(checker.checkOperatorPrecedence, at: filePath))
            }
            
            if checksToRun.contains(.codeStyle) {
                allIssues.append(contentsOf: try runCheck(checker.checkCodeStyle, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.refactoringOpportunities) {
                allIssues.append(contentsOf: try runCheck(checker.checkRefactoringOpportunities, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.symbolUsage) {
                allIssues.append(contentsOf: try runCheck(checker.checkSymbolUsage, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.macroUsage) {
                allIssues.append(contentsOf: try runCheck(checker.checkMacroUsage, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.cycloComplexity) {
                allIssues.append(contentsOf: try runComplexityCheck(checker.checkCyclomaticComplexity, at: filePath, threshold: 10))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.guardUsage) {
                allIssues.append(contentsOf: try runCheck(checker.checkGuardUsage, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.longMethods) {
                allIssues.append(contentsOf: try runComplexityCheck(checker.checkLongMethods, at: filePath, threshold: 50))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.emptyCatchBlocks) {
                allIssues.append(contentsOf: try runCheck(checker.checkEmptyCatchBlocks, at: filePath))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.optionalChainingDepth) {
                allIssues.append(contentsOf: try runComplexityCheck(checker.checkOptionalChainingDepth, at: filePath, threshold: 3))
            }
            
            if checksToRun.isEmpty || checksToRun.contains(.namingConventions) {
                allIssues.append(contentsOf: try runCheck(checker.checkNamingConventions, at: filePath))
            }
            
            // Generate report
            if format == "markdown" {
                return (warning + generateMarkdownReport(issues: allIssues, filePath: filePath), "markdown")
            } else {
                return (warning + generateTextReport(issues: allIssues, filePath: filePath), "text")
            }
        } catch {
            return (warning + "Error analyzing Swift file: \(error.localizedDescription)", "text")
        }
    }
    
    /// Helper method to run a specific check
    private static func runCheck(_ check: (String) throws -> [SourceKitIssue], at path: String) throws -> [SourceKitIssue] {
        do {
            return try check(path)
        } catch {
            print("Warning: Check failed with error: \(error)")
            return []
        }
    }
    
    /// Helper method to run a check that requires additional parameters
    private static func runComplexityCheck(_ check: (String, Int) throws -> [SourceKitIssue], at path: String, threshold: Int) throws -> [SourceKitIssue] {
        do {
            return try check(path, threshold)
        } catch {
            print("Warning: Check failed with error: \(error)")
            return []
        }
    }
    
    /// Analyzes a specific line range of a Swift file
    /// - Parameters:
    ///   - filePath: The path to the Swift file to analyze
    ///   - startLine: The starting line to analyze
    ///   - endLine: The ending line to analyze
    ///   - checksToRun: The individual checks to run
    ///   - format: The output format (markdown or text)
    ///   - warning: Any warning message to include with the results
    /// - Returns: A tuple containing the analysis results and the language of the file
    private static func analyzeFileLineRange(
        filePath: String,
        startLine: Int,
        endLine: Int,
        checksToRun: [IndividualCheck],
        format: String,
        warning: String = ""
    ) -> (String, String) {
        // Check if the line range is valid
        guard startLine > 0, endLine >= startLine else {
            return (warning + String(format: ErrorMessages.invalidLineNumbers), "text")
        }
        
        // Attempt to read the file content
        guard let fileContent = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            return (warning + String(format: ErrorMessages.errorReadingFile, filePath), "text")
        }
        
        // Split the file into lines
        let lines = fileContent.components(separatedBy: .newlines)
        
        // Check if the line range is valid
        guard startLine <= lines.count, endLine <= lines.count else {
            return (warning + "Line range (\(startLine)-\(endLine)) is out of bounds for file with \(lines.count) lines.", "text")
        }
        
        // Extract the requested lines
        // Note: Line numbers are 1-indexed, but array indices are 0-indexed
        let requestedLines = Array(lines[(startLine - 1)..<min(endLine, lines.count)])
        let codeSnippet = requestedLines.joined(separator: "\n")
        
        return analyzeCodeSnippet(
            snippet: codeSnippet,
            originalFilePath: filePath,
            checksToRun: checksToRun,
            format: format,
            warning: warning
        )
    }
    
    /// Analyzes a Swift code snippet by creating a temporary file and running the analyzer on it
    /// - Parameters:
    ///   - snippet: The Swift code snippet to analyze
    ///   - originalFilePath: The original file path (used for reference)
    ///   - checksToRun: The individual checks to run
    ///   - format: The output format (markdown or text)
    ///   - warning: Any warning message to include with the results
    /// - Returns: A tuple containing the analysis results and the language of the file
    private static func analyzeCodeSnippet(
        snippet: String,
        originalFilePath: String,
        checksToRun: [IndividualCheck],
        format: String,
        warning: String = ""
    ) -> (String, String) {
        // Create a temporary file with the snippet
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileName = "xcf_snippet_\(UUID().uuidString).swift"
        let tempFilePath = tempDir.appendingPathComponent(tempFileName).path
        
        do {
            try snippet.write(toFile: tempFilePath, atomically: true, encoding: .utf8)
            
            // Analyze the snippet using the same method as analyzing an entire file
            let (result, language) = analyzeEntireFile(
                filePath: tempFilePath,
                checksToRun: checksToRun,
                format: format,
                warning: ""
            )
            
            // Clean up the temporary file
            try? FileManager.default.removeItem(atPath: tempFilePath)
            
            // Customize the report for a snippet
            var report = result
            
            // For markdown reports, add more context about the snippet
            if language == "markdown" {
                report = report.replacingOccurrences(
                    of: "# Swift Code Analysis Report",
                    with: "# Swift Code Analysis Report (Snippet)"
                )
                
                report = report.replacingOccurrences(
                    of: "## File: \(tempFilePath)",
                    with: "## Original File: \(originalFilePath)\n\n```swift\n\(snippet)\n```"
                )
            }
            
            return (warning + report, language)
        } catch {
            return (warning + "Error creating temporary file for analysis: \(error.localizedDescription)", "text")
        }
    }
    
    /// Generates a Markdown report from the analysis results
    /// - Parameters:
    ///   - issues: The issues found during analysis
    ///   - filePath: The path to the analyzed file
    /// - Returns: A formatted Markdown report
    private static func generateMarkdownReport(issues: [SourceKitIssue], filePath: String) -> String {
        if issues.isEmpty {
            return "# Swift Code Analysis Report\n\n## File: \(filePath)\n\n✅ No issues found in this file."
        }
        
        // Group issues by severity
        let issuesByType = Dictionary(grouping: issues, by: { $0.severity })
        var report = "# Swift Code Analysis Report\n\n"
        report += "## File: \(filePath)\n\n"
        
        // Show issue count by severity
        let errorCount = issuesByType["error"]?.count ?? 0
        let warningCount = issuesByType["warning"]?.count ?? 0
        let infoCount = issuesByType["info"]?.count ?? 0
        
        report += "**Summary:** 🛑 \(errorCount) errors, ⚠️ \(warningCount) warnings, 💡 \(infoCount) info\n\n"
        
        // Group by categories for better organization
        let categories = groupIssuesByCategory(issues)
        if !categories.isEmpty {
            report += "## Issues by Category\n\n"
            
            for (category, count) in categories.sorted(by: { $0.key < $1.key }) {
                report += "- **\(category)**: \(count)\n"
            }
            
            report += "\n"
        }
        
        // Show issues by severity
        for severity in ["error", "warning", "info"] {
            if let severityIssues = issuesByType[severity], !severityIssues.isEmpty {
                // Add emojis to severity headers
                let severityEmoji = severity == "error" ? "🛑 " : (severity == "warning" ? "⚠️ " : "💡 ")
                report += "## \(severityEmoji)\(severity.capitalized)s\n\n"
                
                // Group issues by description to identify repetitive issues
                let issuesByDescription = Dictionary(grouping: severityIssues, by: { $0.description })
                
                // Process each type of issue
                for (description, issuesWithSameDescription) in issuesByDescription.sorted(by: { $0.value.count > $1.value.count }) {
                    if issuesWithSameDescription.count > 5 {
                        // Summarize issues that occur more than 5 times
                        let lineNumbers = issuesWithSameDescription.map { $0.line }.sorted()
                        let firstFew = lineNumbers.prefix(3).map { String($0) }.joined(separator: ", ")
                        let lastFew = lineNumbers.suffix(2).map { String($0) }.joined(separator: ", ")
                        
                        report += "- **\(issuesWithSameDescription.count) occurrences**: \(description)\n"
                        report += "  - Lines: \(firstFew), ... , \(lastFew) (and \(lineNumbers.count - 5) more)\n"
                    } else {
                        // Show individual issues when there are 5 or fewer
                        for issue in issuesWithSameDescription.sorted(by: { $0.line < $1.line }) {
                            let location = issue.line > 0 ? "**Line \(issue.line)**" : "**File**"
                            report += "- \(location): \(issue.description)\n"
                        }
                    }
                }
                
                report += "\n"
            }
        }
        
        return report
    }
    
    /// Generates a plain text report from the analysis results
    /// - Parameters:
    ///   - issues: The issues found during analysis
    ///   - filePath: The path to the analyzed file
    /// - Returns: A formatted text report
    private static func generateTextReport(issues: [SourceKitIssue], filePath: String) -> String {
        if issues.isEmpty {
            return "Analysis of \(filePath)\n\n✅ No issues found in this file."
        }
        
        // Group issues by severity
        let issuesByType = Dictionary(grouping: issues, by: { $0.severity })
        var report = "Analysis of \(filePath)\n\n"
        
        // Show issue count by severity
        let errorCount = issuesByType["error"]?.count ?? 0
        let warningCount = issuesByType["warning"]?.count ?? 0
        let infoCount = issuesByType["info"]?.count ?? 0
        
        report += "Summary: 🛑 \(errorCount) errors, ⚠️ \(warningCount) warnings, 💡 \(infoCount) info\n\n"
        
        // Show issues by severity
        for severity in ["error", "warning", "info"] {
            if let severityIssues = issuesByType[severity], !severityIssues.isEmpty {
                // Add emojis to severity headers
                let severityEmoji = severity == "error" ? "🛑 " : (severity == "warning" ? "⚠️ " : "💡 ")
                report += "\(severityEmoji)\(severity.uppercased())S:\n"
                
                // Group issues by description to identify repetitive issues
                let issuesByDescription = Dictionary(grouping: severityIssues, by: { $0.description })
                
                // Process each type of issue
                for (description, issuesWithSameDescription) in issuesByDescription.sorted(by: { $0.value.count > $1.value.count }) {
                    if issuesWithSameDescription.count > 5 {
                        // Summarize issues that occur more than 5 times
                        let lineNumbers = issuesWithSameDescription.map { $0.line }.sorted()
                        let firstFew = lineNumbers.prefix(3).map { String($0) }.joined(separator: ", ")
                        let lastFew = lineNumbers.suffix(2).map { String($0) }.joined(separator: ", ")
                        
                        report += "- \(issuesWithSameDescription.count) occurrences: \(description)\n"
                        report += "  Lines: \(firstFew), ... , \(lastFew) (and \(lineNumbers.count - 5) more)\n"
                    } else {
                        // Show individual issues when there are 5 or fewer
                        for issue in issuesWithSameDescription.sorted(by: { $0.line < $1.line }) {
                            let location = issue.line > 0 ? "Line \(issue.line)" : "File"
                            report += "- \(location): \(issue.description)\n"
                        }
                    }
                }
                
                report += "\n"
            }
        }
        
        return report
    }
    
    /// Groups issues by category for better organization
    /// - Parameter issues: The issues to group
    /// - Returns: A dictionary mapping category names to issue counts
    private static func groupIssuesByCategory(_ issues: [SourceKitIssue]) -> [String: Int] {
        var categories: [String: Int] = [:]
        
        for issue in issues {
            let category = determineCategory(for: issue)
            categories[category, default: 0] += 1
        }
        
        return categories
    }
    
    /// Determines the category for an issue based on its description
    /// - Parameter issue: The issue to categorize
    /// - Returns: The category name
    private static func determineCategory(for issue: SourceKitIssue) -> String {
        let description = issue.description.lowercased()
        
        if description.contains("unused") {
            return "Unused Variables"
        } else if description.contains("unwrap") || description.contains("optional") {
            return "Force Unwraps"
        } else if description.contains("let") && description.contains("cannot") {
            return "Immutable Assignments"
        } else if description.contains("unreachable") {
            return "Unreachable Code"
        } else if description.contains("operator") {
            return "Operator Precedence"
        } else if description.contains("style") || description.contains("whitespace") || description.contains("indentation") {
            return "Code Style"
        } else if description.contains("refactor") || description.contains("extract") || description.contains("large") {
            return "Refactoring Opportunities"
        } else if description.contains("symbol") {
            return "Symbol Usage"
        } else if description.contains("macro") {
            return "Macro Usage"
        } else if description.contains("complexity") {
            return "Cyclomatic Complexity"
        } else if description.contains("guard") {
            return "Guard Usage"
        } else if description.contains("method") && description.contains("long") {
            return "Long Methods"
        } else if description.contains("catch") && description.contains("empty") {
            return "Exception Handling"
        } else if description.contains("naming") || description.contains("name") {
            return "Naming Conventions"
        } else if description.contains("syntax") || description.contains("parsing") {
            return "Syntax"
        } else {
            return "Other Issues"
        }
    }
