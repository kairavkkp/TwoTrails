import Foundation

enum Person: String, Codable, CaseIterable, Identifiable {
    case him, her
    var id: String { rawValue }
    var displayName: String { self == .him ? "Him" : "Her" }
}

struct ExerciseItem: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let sets: String
}

struct WorkoutVariant: Codable {
    let label: String
    let exercises: [ExerciseItem]
}

enum DayKind: Equatable {
    case gym(variant: String)
    case walk
    case rest

    var label: String {
        switch self {
        case .gym(let v): return "Gym day — Full body \(v)"
        case .walk: return "Walk day"
        case .rest: return "Rest day"
        }
    }
}

enum Plan {
    static let him: [String: WorkoutVariant] = [
        "A": WorkoutVariant(label: "Full body A", exercises: [
            ExerciseItem(id: "h_a1", name: "Barbell squat", sets: "4x6-8"),
            ExerciseItem(id: "h_a2", name: "Bench press", sets: "4x6-8"),
            ExerciseItem(id: "h_a3", name: "Barbell row", sets: "3x8-10"),
            ExerciseItem(id: "h_a4", name: "Plank", sets: "3x30-45s")
        ]),
        "B": WorkoutVariant(label: "Full body B", exercises: [
            ExerciseItem(id: "h_b1", name: "Deadlift", sets: "3x5"),
            ExerciseItem(id: "h_b2", name: "Overhead press", sets: "4x6-8"),
            ExerciseItem(id: "h_b3", name: "Pulldown or pull-ups", sets: "3x8-10"),
            ExerciseItem(id: "h_b4", name: "Hanging knee raise", sets: "3x10-12")
        ]),
        "C": WorkoutVariant(label: "Full body C", exercises: [
            ExerciseItem(id: "h_c1", name: "Front squat or leg press", sets: "4x8"),
            ExerciseItem(id: "h_c2", name: "Incline DB press", sets: "3x8-10"),
            ExerciseItem(id: "h_c3", name: "Seated cable row", sets: "3x10"),
            ExerciseItem(id: "h_c4", name: "Farmer's carry", sets: "3x30m")
        ])
    ]

    static let her: [String: WorkoutVariant] = [
        "A": WorkoutVariant(label: "Full body A", exercises: [
            ExerciseItem(id: "w_a1", name: "Goblet squat", sets: "3x10"),
            ExerciseItem(id: "w_a2", name: "Push-ups", sets: "3x8-10"),
            ExerciseItem(id: "w_a3", name: "Seated row", sets: "3x10"),
            ExerciseItem(id: "w_a4", name: "Dead bug", sets: "3x10/side")
        ]),
        "B": WorkoutVariant(label: "Full body B", exercises: [
            ExerciseItem(id: "w_b1", name: "Romanian deadlift", sets: "3x10"),
            ExerciseItem(id: "w_b2", name: "DB shoulder press", sets: "3x10"),
            ExerciseItem(id: "w_b3", name: "Lat pulldown", sets: "3x10"),
            ExerciseItem(id: "w_b4", name: "Plank", sets: "3x20-30s")
        ]),
        "C": WorkoutVariant(label: "Full body C", exercises: [
            ExerciseItem(id: "w_c1", name: "Step-ups or leg press", sets: "3x10"),
            ExerciseItem(id: "w_c2", name: "Incline push-up or chest press", sets: "3x10"),
            ExerciseItem(id: "w_c3", name: "Band pull-apart", sets: "3x12"),
            ExerciseItem(id: "w_c4", name: "Side plank", sets: "2x20s/side")
        ])
    ]

    static func variants(for person: Person) -> [String: WorkoutVariant] {
        person == .him ? him : her
    }

    // Sunday = 1 ... Saturday = 7 (Calendar.component(.weekday))
    static let schedule: [Int: DayKind] = [
        1: .rest,
        2: .walk,
        3: .gym(variant: "A"),
        4: .walk,
        5: .gym(variant: "B"),
        6: .walk,
        7: .gym(variant: "C")
    ]

    static func dayKind(for date: Date) -> DayKind {
        let weekday = Calendar.current.component(.weekday, from: date)
        return schedule[weekday] ?? .rest
    }
}
