import Foundation
import Combine

/// Manages flexible workout scheduling
final class ScheduleStore: ObservableObject {
    @Published var schedules: [Person: WeeklySchedule] = [:]
    
    private let userDefaultsKey = "TwoTrails.WeeklySchedules"
    
    init() {
        loadSchedules()
    }
    
    // MARK: - Public Methods
    
    func getSchedule(for person: Person) -> WeeklySchedule {
        if let existing = schedules[person] {
            return existing
        }
        // Return default schedule
        return WeeklySchedule.default(for: person)
    }
    
    func assignWorkout(_ variantKey: String?, to weekday: Int, for person: Person) {
        var schedule = getSchedule(for: person)
        schedule.assignments[weekday] = variantKey
        schedules[person] = schedule
        saveSchedules()
    }
    
    func getAssignedWorkout(for date: Date, person: Person) -> String? {
        let weekday = Calendar.current.component(.weekday, from: date)
        return getSchedule(for: person).assignments[weekday] ?? nil
    }
    
    func resetToDefault(for person: Person) {
        schedules[person] = WeeklySchedule.default(for: person)
        saveSchedules()
    }
    
    // MARK: - Persistence
    
    private func saveSchedules() {
        let encoder = JSONEncoder()
        var encodableData: [String: WeeklySchedule] = [:]
        
        for (person, schedule) in schedules {
            encodableData[person.rawValue] = schedule
        }
        
        if let encoded = try? encoder.encode(encodableData) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadSchedules() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        let decoder = JSONDecoder()
        
        if let decoded = try? decoder.decode([String: WeeklySchedule].self, from: data) {
            var result: [Person: WeeklySchedule] = [:]
            for (personRaw, schedule) in decoded {
                if let person = Person(rawValue: personRaw) {
                    result[person] = schedule
                }
            }
            schedules = result
        }
    }
}

// MARK: - Data Models

struct WeeklySchedule: Codable {
    var assignments: [Int: String?] // weekday (1-7) -> variant key ("A", "B", "C") or nil for rest/walk
    
    init(assignments: [Int: String?] = [:]) {
        self.assignments = assignments
    }
    
    static func `default`(for person: Person) -> WeeklySchedule {
        // Default 3-day split: Tue, Thu, Sat
        return WeeklySchedule(assignments: [
            1: nil,      // Sunday - Rest
            2: nil,      // Monday - Walk only
            3: "A",      // Tuesday - Workout A
            4: nil,      // Wednesday - Walk only
            5: "B",      // Thursday - Workout B
            6: nil,      // Friday - Walk only
            7: "C"       // Saturday - Workout C
        ])
    }
}
