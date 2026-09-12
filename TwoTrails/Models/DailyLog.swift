import Foundation

struct DailyLog: Codable, Equatable {
    var walkMinutes: Int = 0
    var exChecked: [String: Bool] = [:]

    var walked: Bool { walkMinutes > 0 }

    func completedCount(for exercises: [ExerciseItem]) -> Int {
        exercises.filter { exChecked[$0.id] == true }.count
    }

    func allCompleted(for exercises: [ExerciseItem]) -> Bool {
        !exercises.isEmpty && exercises.allSatisfy { exChecked[$0.id] == true }
    }
}

/// Key format: "yyyy-MM-dd:person"
enum LogKey {
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = TimeZone.current
        return f
    }()

    static func make(date: Date, person: Person) -> String {
        "\(formatter.string(from: date)):\(person.rawValue)"
    }

    static func dateString(_ date: Date) -> String {
        formatter.string(from: date)
    }
}
