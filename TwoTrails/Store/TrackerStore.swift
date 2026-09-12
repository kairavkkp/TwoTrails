import Foundation
import Combine

final class TrackerStore: ObservableObject {
    @Published private(set) var logs: [String: DailyLog] = [:]

    private let persistence: LogPersisting

    init(persistence: LogPersisting = UserDefaultsLogStore()) {
        self.persistence = persistence
        self.logs = persistence.loadAll()
    }

    func log(for date: Date, person: Person) -> DailyLog {
        logs[LogKey.make(date: date, person: person)] ?? DailyLog()
    }

    func setWalkMinutes(_ minutes: Int, date: Date, person: Person) {
        let key = LogKey.make(date: date, person: person)
        var entry = logs[key] ?? DailyLog()
        entry.walkMinutes = (entry.walkMinutes == minutes) ? 0 : minutes
        logs[key] = entry
        persist()
    }

    func toggleExercise(_ exerciseID: String, date: Date, person: Person) {
        let key = LogKey.make(date: date, person: person)
        var entry = logs[key] ?? DailyLog()
        entry.exChecked[exerciseID] = !(entry.exChecked[exerciseID] ?? false)
        logs[key] = entry
        persist()
    }

    private func persist() {
        persistence.save(logs)
    }
}
