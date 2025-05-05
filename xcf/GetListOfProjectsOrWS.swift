import Foundation

func getListOfProjectsOrWorkspacesRecursively(inFolderPath folderPath: String, depth: Int = 0, maxDepth: Int = 3, proj: Bool) -> [String] {
    if depth > maxDepth {
        return []
    }
    
    let fileManager = FileManager.default
    var projects: [String] = []
    
    guard let contents = try? fileManager.contentsOfDirectory(atPath: folderPath) else { return [] }
    
    for item in contents {
        let itemPath = URL(fileURLWithPath: folderPath).appendingPathComponent(item).path
        
        if proj && item.hasSuffix(".xcodeproj") {
            projects.append(itemPath)
        }
        
        if !proj && item.hasSuffix(".xcworkspace") {
            projects.append(itemPath)
        }
        
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: itemPath, isDirectory: &isDir) && isDir.boolValue {
            let subfolderProjects = getListOfProjectsOrWorkspacesRecursively(inFolderPath: itemPath, depth: depth + 1, maxDepth: maxDepth, proj: proj)
            projects.append(contentsOf: subfolderProjects)
        }
    }
    
    return projects
}

func listProjectsOrWorkspacesIn(_ directive: String, _ parentFolderPath: String, proj: Bool) -> String {
    let startIndex = directive.index(directive.startIndex, offsetBy: parentFolderPath.count)
    let folderPath = String(directive[startIndex...]).trimmingCharacters(in: .whitespaces)
    
    // Handle tilde expansion for home directory
    defaultFolderPath = folderPath
    if folderPath.starts(with: "~") {
        if let homeDir = ProcessInfo.processInfo.environment["HOME"] {
            defaultFolderPath = folderPath.replacingOccurrences(of: "~", with: homeDir)
        }
    }
    
    let projects = getListOfProjectsOrWorkspacesRecursively(inFolderPath: defaultFolderPath, proj: proj)
    var result = "List of Projects in \(folderPath)!!"
    
    if projects.isEmpty {
        result += "\nNo projects found in \(folderPath)."
    } else {
        for (index, project) in projects.enumerated() {
            result += "\n\(index + 1). \(project)"
        }
    }
    
    return result
}

func getListOfProjects(inFolderPath folderPath: String) -> [String] {
    let fileManager = FileManager.default
    var projects: [String] = []

    guard let contents = try? fileManager.contentsOfDirectory(atPath: folderPath) else { return [] }
    
    for item in contents {
        if item.hasSuffix(".xcodeproj") {
            projects.append(URL(fileURLWithPath: folderPath).appendingPathComponent(item).path)
        }
    }
    
    for item in contents {
        if item.hasSuffix(".xcworkspace") {
            projects.append(URL(fileURLWithPath: folderPath).appendingPathComponent(item).path)
        }
    }
    
    if projects.isEmpty {
        return []
    } else {
        return projects
    }
}
