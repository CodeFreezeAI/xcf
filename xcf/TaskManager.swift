//import Foundation
//
//// Protocol defining task capabilities with additional metadata
//protocol Taskable {
//    var id: UUID { get }
//    var title: String { get set }
//    var description: String { get set }
//    var priority: Priority { get set }
//    var status: Status { get set }
//    var createdAt: Date { get }
//    var updatedAt: Date { get }
//    
//    mutating func updateStatus(to newStatus: Status)
//}
//
//// Enhanced Priority enum with color and emoji representation
//enum Priority: Int, Comparable, CaseIterable {
//    case low = 1
//    case medium = 2
//    case high = 3
//    case critical = 4
//    
//    var color: String {
//        switch self {
//        case .low: return "🟢"
//        case .medium: return "🟡"
//        case .high: return "🟠"
//        case .critical: return "🔴"
//        }
//    }
//    
//    var emoji: String {
//        switch self {
//        case .low: return "😌"
//        case .medium: return "🤔"
//        case .high: return "😰"
//        case .critical: return "🚨"
//        }
//    }
//    
//    static func < (lhs: Priority, rhs: Priority) -> Bool {
//        return lhs.rawValue < rhs.rawValue
//    }
//}
//
//// Enhanced Status enum with more descriptive cases
//enum Status: String, CaseIterable {
//    case todo = "To Do"
//    case inProgress = "In Progress"
//    case completed = "Completed"
//    case onHold = "On Hold"
//    case cancelled = "Cancelled"
//}
//
//// Struct representing a task with more robust implementation
//struct Task: Taskable, Identifiable {
//    let id: UUID
//    var title: String
//    var description: String
//    var priority: Priority
//    var status: Status
//    let createdAt: Date
//    var updatedAt: Date
//    
//    init(title: String, description: String, priority: Priority = .medium) {
//        self.id = UUID()
//        self.title = title
//        self.description = description
//        self.priority = priority
//        self.status = .todo
//        self.createdAt = Date()
//        self.updatedAt = Date()
//    }
//    
//    mutating func updateStatus(to newStatus: Status) {
//        self.status = newStatus
//        self.updatedAt = Date()
//    }
//}
//
//// Enhanced TaskManager with more advanced functionality
//class TaskManager {
//    private var tasks: [Task] = []
//    
//    func addTask(_ task: Task) {
//        tasks.append(task)
//    }
//    
//    func listTasks(
//        sortedBy priority: Bool = false,
//        filterBy status: Status? = nil
//    ) -> [Task] {
//        var filteredTasks = status != nil 
//            ? tasks.filter { $0.status == status } 
//            : tasks
//        
//        return priority 
//            ? filteredTasks.sorted { $0.priority > $1.priority } 
//            : filteredTasks
//    }
//    
//    func completeTask(withID id: UUID) -> Bool {
//        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
//            return false
//        }
//        tasks[index].updateStatus(to: .completed)
//        return true
//    }
//    
//    // New method to get tasks by priority
//    func tasksByPriority() -> [Priority: [Task]] {
//        return Dictionary(grouping: tasks, by: { $0.priority })
//    }
//}
