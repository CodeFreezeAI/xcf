import Foundation
import SwiftUI

// Metadata struct to track document properties
struct DocumentMetadata {
    var title: String
    var createdAt: Date
    var lastModified: Date?
    var version: Double
    
    init(title: String, createdAt: Date, version: Double) {
        self.title = title
        self.createdAt = createdAt
        self.version = version
    }
}

// Complex Swift class to demonstrate document manipulation
class DocumentManipulationTest {
    // Properties to simulate a complex data model
    private var items: [String] = []
    private var configuration: [String: Any] = [:]
    private var metadata: DocumentMetadata
    private var version: Int = 1
    
    // Initializer with extended configuration options
    init(initialItems: [String] = [], 
         initialConfig: [String: Any] = [:], 
         title: String = "Default Document") {
        self.items = initialItems
        self.configuration = initialConfig
        self.metadata = DocumentMetadata(
            title: title,
            createdAt: Date(),
            version: Double(version)
        )
    }
    
    // Method to add items
    func addItem(_ item: String) {
        items.append(item)
        updateMetadata()
    }
    
    // Method to remove items
    func removeItem(_ item: String) {
        items.removeAll { $0 == item }
        updateMetadata()
    }
    
    // Method to update configuration
    func updateConfiguration(key: String, value: Any) {
        configuration[key] = value
        updateMetadata()
    }
    
    // Private method to update metadata
    private func updateMetadata() {
        metadata.lastModified = Date()
        metadata.version += 0.1
    }
    
    // Method to get current state
    func getCurrentState() -> [String: Any] {
        return [
            "items": items,
            "configuration": configuration,
            "metadata": metadata
        ]
    }
    
    // Generate report about the document
    func generateReport() -> String {
        var report = "Document Report\n"
        report += "===============\n"
        report += "Total Items: \(items.count)\n"
        report += "Configuration Keys: \(configuration.keys.count)\n"
        report += "Last Modified: \(metadata.lastModified?.description ?? "Never")\n"
        return report
    }
}

// Validate document state
func validateDocumentState(_ doc: DocumentManipulationTest) -> Bool {
    let state = doc.getCurrentState()
    guard let items = state["items"] as? [String],
          let configuration = state["configuration"] as? [String: Any],
          let metadata = state["metadata"] as? DocumentMetadata else {
        return false
    }
    
    return items.count > 0 && 
           !configuration.isEmpty && 
           metadata.version > 1.0
}

// Demonstration of complex logic
func demonstrateDocumentManipulation() {
    let doc = DocumentManipulationTest()
    
    // Simulate document manipulation
    doc.addItem("First Item")
    doc.addItem("Second Item")
    doc.updateConfiguration(key: "theme", value: "dark")
    doc.updateConfiguration(key: "language", value: "Swift")
    
    print(doc.generateReport())
    print(doc.getCurrentState())
}

// Main execution
func main() {
    let testDoc = DocumentManipulationTest()
    testDoc.addItem("Test Item")
    testDoc.updateConfiguration(key: "test", value: true)
    
    if validateDocumentState(testDoc) {
        print("Document state is valid!")
    } else {
        print("Document state is invalid.")
    }
    
    demonstrateDocumentManipulation()
}

// Run the main function
// Uncomment to run
// main()