import Foundation

func getListOfProjectsRecursively(inFolderPath folderPath: String, depth: Int = 0, maxDepth: Int = 10) -> [String] {
    if depth > maxDepth {
        return []
    }
    
    let fileManager = FileManager.default
    var projects: [String] = []
    
    // Get all items in the directory
    guard let contents = try? fileManager.contentsOfDirectory(atPath: folderPath) else { return [] }
    
    // Look for xcodeproj files
    for item in contents {
        let itemPath = URL(fileURLWithPath: folderPath).appendingPathComponent(item).path
        
        if item.hasSuffix(".xcodeproj") {
            projects.append(itemPath)
        }
        
        // Check for xcworkspace files
        if item.hasSuffix(".xcworkspace") {
            projects.append(itemPath)
        }
        
        // Recursively check subdirectories
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: itemPath, isDirectory: &isDir) && isDir.boolValue {
            let subfolderProjects = getListOfProjectsRecursively(inFolderPath: itemPath, depth: depth + 1, maxDepth: maxDepth)
            projects.append(contentsOf: subfolderProjects)
        }
    }
    
    return projects
}

func getListOfProjects(inFolderPath folderPath: String) -> [String] {
    let fileManager = FileManager.default
    var projects: [String] = []
    // Get all items in the directory
    guard let contents = try? fileManager.contentsOfDirectory(atPath: folderPath) else { return [] }
    
    // First look for xcodeproj files
    for item in contents {
        if item.hasSuffix(".xcodeproj") {
            projects.append(URL(fileURLWithPath: folderPath).appendingPathComponent(item).path)
        }
    }
    
    // If no xcodeproj found, look for xcworkspace files
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
