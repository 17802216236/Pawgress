import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    var username: String
    var streakCount: Int
    var lastCheckInDate: Date?
    
    init(id: String, email: String, username: String) {
        self.id = id
        self.email = email
        self.username = username
        self.streakCount = 0
        self.lastCheckInDate = nil
    }
} 