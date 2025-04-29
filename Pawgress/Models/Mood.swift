import Foundation

struct Mood: Identifiable, Codable {
    let id: String
    var emoji: String
    var note: String
    var date: Date
    
    init(id: String = UUID().uuidString, emoji: String, note: String = "", date: Date = Date()) {
        self.id = id
        self.emoji = emoji
        self.note = note
        self.date = date
    }
}

enum MoodEmoji: String, CaseIterable {
    case happy = "😊"
    case sad = "😢"
    case angry = "😠"
    case anxious = "😰"
    case calm = "😌"
    case excited = "🤩"
    case tired = "😴"
    case neutral = "😐"
} 