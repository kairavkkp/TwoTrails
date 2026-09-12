import Foundation

/// Abstraction over how logs are persisted. Today this is backed by
/// UserDefaults (local, per-device). To add cross-device sync later,
/// write a CloudKitLogStore that conforms to this same protocol and
/// swap it into TrackerStore's initializer — no view code changes needed.
protocol LogPersisting {
    func loadAll() -> [String: DailyLog]
    func save(_ logs: [String: DailyLog])
}

final class UserDefaultsLogStore: LogPersisting {
    private let key = "twotrails.logs.v1"
    private let defaults = UserDefaults.standard

    func loadAll() -> [String: DailyLog] {
        guard let data = defaults.data(forKey: key) else { return [:] }
        return (try? JSONDecoder().decode([String: DailyLog].self, from: data)) ?? [:]
    }

    func save(_ logs: [String: DailyLog]) {
        guard let data = try? JSONEncoder().encode(logs) else { return }
        defaults.set(data, forKey: key)
    }
}
