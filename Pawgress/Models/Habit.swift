import Foundation

struct Habit: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var isCompleted: Bool
    var completionDates: [Date]
    
    init(id: String = UUID().uuidString, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = false
        self.completionDates = []
    }
} 