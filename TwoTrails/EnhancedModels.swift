import Foundation

// MARK: - Set-Level Exercise Tracking

/// Represents a single set within an exercise
struct ExerciseSet: Identifiable, Codable, Hashable {
    let id: String
    var reps: Int
    var weight: Double // in kg or lbs
    var isCompleted: Bool
    var restTime: Int? // in seconds
    var notes: String?
    
    init(id: String = UUID().uuidString,
         reps: Int = 10,
         weight: Double = 0,
         isCompleted: Bool = false,
         restTime: Int? = nil,
         notes: String? = nil) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.isCompleted = isCompleted
        self.restTime = restTime
        self.notes = notes
    }
    
    var volume: Double {
        Double(reps) * weight
    }
}

/// Enhanced exercise item with set-level tracking
struct PlannedExercise: Identifiable, Codable, Hashable {
    let id: String
    var exerciseTemplate: ExerciseTemplate
    var sets: [ExerciseSet]
    var order: Int // Position in workout
    var notes: String?
    
    init(id: String = UUID().uuidString,
         exerciseTemplate: ExerciseTemplate,
         sets: [ExerciseSet] = [],
         order: Int = 0,
         notes: String? = nil) {
        self.id = id
        self.exerciseTemplate = exerciseTemplate
        self.sets = sets.isEmpty ? [ExerciseSet()] : sets // At least 1 set
        self.order = order
        self.notes = notes
    }
    
    // Legacy compatibility - create from old ExerciseItem
    init(from legacy: ExerciseItem, template: ExerciseTemplate, order: Int = 0) {
        self.id = legacy.id
        self.exerciseTemplate = template
        self.order = order
        self.notes = nil
        
        // Parse "3x10" or "4x6-8" format
        let parts = legacy.sets.split(separator: "x")
        if parts.count == 2,
           let setCount = Int(parts[0]) {
            let repsString = String(parts[1])
            let reps = Int(repsString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 10
            
            self.sets = (0..<setCount).map { _ in
                ExerciseSet(reps: reps, weight: 0)
            }
        } else {
            self.sets = [ExerciseSet()]
        }
    }
    
    var totalVolume: Double {
        sets.reduce(0) { $0 + $1.volume }
    }
    
    var completedSets: Int {
        sets.filter { $0.isCompleted }.count
    }
    
    var isFullyCompleted: Bool {
        !sets.isEmpty && sets.allSatisfy { $0.isCompleted }
    }
    
    // For display compatibility
    var displaySummary: String {
        "\(sets.count) sets"
    }
}

/// Enhanced workout variant with set-level tracking
struct EnhancedWorkoutVariant: Identifiable, Codable {
    let id: String
    var label: String
    var exercises: [PlannedExercise]
    var weekday: Int? // 1-7, nil = any day
    var notes: String?
    
    init(id: String = UUID().uuidString,
         label: String,
         exercises: [PlannedExercise] = [],
         weekday: Int? = nil,
         notes: String? = nil) {
        self.id = id
        self.label = label
        self.exercises = exercises.sorted { $0.order < $1.order }
        self.weekday = weekday
        self.notes = notes
    }
    
    // Legacy compatibility
    init(from legacy: WorkoutVariant, weekday: Int? = nil) {
        self.id = UUID().uuidString
        self.label = legacy.label
        self.weekday = weekday
        self.notes = nil
        
        // Convert old exercises to new format with templates
        self.exercises = legacy.exercises.enumerated().map { index, oldEx in
            // Try to find matching template
            let template = ExerciseLibrary.allExercises.first {
                $0.name.localizedCaseInsensitiveContains(oldEx.name) ||
                oldEx.name.localizedCaseInsensitiveContains($0.name)
            } ?? ExerciseTemplate(
                name: oldEx.name,
                primaryMuscle: .fullBody,
                equipment: .other,
                category: .compound
            )
            
            return PlannedExercise(from: oldEx, template: template, order: index)
        }
    }
    
    var totalVolume: Double {
        exercises.reduce(0) { $0 + $1.totalVolume }
    }
    
    var completionPercentage: Double {
        guard !exercises.isEmpty else { return 0 }
        let totalSets = exercises.reduce(0) { $0 + $1.sets.count }
        guard totalSets > 0 else { return 0 }
        let completedSets = exercises.reduce(0) { $0 + $1.completedSets }
        return Double(completedSets) / Double(totalSets)
    }
}

// MARK: - Daily Log Enhancement

struct EnhancedDailyLog: Codable, Equatable {
    var walkMinutes: Int
    var workoutPerformed: EnhancedWorkoutVariant?
    var date: Date
    var notes: String?
    
    init(walkMinutes: Int = 0,
         workoutPerformed: EnhancedWorkoutVariant? = nil,
         date: Date = Date(),
         notes: String? = nil) {
        self.walkMinutes = walkMinutes
        self.workoutPerformed = workoutPerformed
        self.date = date
        self.notes = notes
    }
    
    var walked: Bool { walkMinutes > 0 }
    
    var hasWorkout: Bool { workoutPerformed != nil }
    
    var totalVolume: Double {
        workoutPerformed?.totalVolume ?? 0
    }
}
