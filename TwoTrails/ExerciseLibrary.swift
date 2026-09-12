import Foundation

// MARK: - Exercise Library

enum MuscleGroup: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case legs = "Legs"
    case glutes = "Glutes"
    case hamstrings = "Hamstrings"
    case quadriceps = "Quadriceps"
    case calves = "Calves"
    case core = "Core"
    case fullBody = "Full Body"
    case cardio = "Cardio"
}

enum EquipmentType: String, Codable, CaseIterable {
    case barbell = "Barbell"
    case dumbbell = "Dumbbell"
    case cable = "Cable"
    case machine = "Machine"
    case bodyweight = "Bodyweight"
    case kettlebell = "Kettlebell"
    case band = "Resistance Band"
    case other = "Other"
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case compound = "Compound"
    case isolation = "Isolation"
    case cardio = "Cardio"
    case flexibility = "Flexibility"
}

struct ExerciseTemplate: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let primaryMuscle: MuscleGroup
    let secondaryMuscles: [MuscleGroup]
    let equipment: EquipmentType
    let category: ExerciseCategory
    let instructions: String?
    
    init(id: String = UUID().uuidString,
         name: String,
         primaryMuscle: MuscleGroup,
         secondaryMuscles: [MuscleGroup] = [],
         equipment: EquipmentType,
         category: ExerciseCategory,
         instructions: String? = nil) {
        self.id = id
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.category = category
        self.instructions = instructions
    }
}

// MARK: - Exercise Library Database

enum ExerciseLibrary {
    static let allExercises: [ExerciseTemplate] = [
        // CHEST
        ExerciseTemplate(name: "Barbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Incline Barbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Dumbbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Incline Dumbbell Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Dumbbell Flyes", primaryMuscle: .chest, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Cable Flyes", primaryMuscle: .chest, equipment: .cable, category: .isolation),
        ExerciseTemplate(name: "Push-ups", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders, .core], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Chest Press Machine", primaryMuscle: .chest, secondaryMuscles: [.triceps], equipment: .machine, category: .compound),
        
        // BACK
        ExerciseTemplate(name: "Deadlift", primaryMuscle: .back, secondaryMuscles: [.hamstrings, .glutes, .core], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Romanian Deadlift", primaryMuscle: .hamstrings, secondaryMuscles: [.back, .glutes], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Barbell Row", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Dumbbell Row", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Seated Cable Row", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .cable, category: .compound),
        ExerciseTemplate(name: "Lat Pulldown", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .cable, category: .compound),
        ExerciseTemplate(name: "Pull-ups", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Chin-ups", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "T-Bar Row", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .barbell, category: .compound),
        
        // SHOULDERS
        ExerciseTemplate(name: "Overhead Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Dumbbell Shoulder Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Lateral Raises", primaryMuscle: .shoulders, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Front Raises", primaryMuscle: .shoulders, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Face Pulls", primaryMuscle: .shoulders, secondaryMuscles: [.back], equipment: .cable, category: .isolation),
        ExerciseTemplate(name: "Arnold Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], equipment: .dumbbell, category: .compound),
        
        // LEGS
        ExerciseTemplate(name: "Barbell Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings, .core], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Front Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .core], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Goblet Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Leg Press", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], equipment: .machine, category: .compound),
        ExerciseTemplate(name: "Leg Extension", primaryMuscle: .quadriceps, equipment: .machine, category: .isolation),
        ExerciseTemplate(name: "Leg Curl", primaryMuscle: .hamstrings, equipment: .machine, category: .isolation),
        ExerciseTemplate(name: "Lunges", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Bulgarian Split Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Step-ups", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Calf Raises", primaryMuscle: .calves, equipment: .machine, category: .isolation),
        
        // ARMS
        ExerciseTemplate(name: "Barbell Curl", primaryMuscle: .biceps, equipment: .barbell, category: .isolation),
        ExerciseTemplate(name: "Dumbbell Curl", primaryMuscle: .biceps, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Hammer Curl", primaryMuscle: .biceps, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Preacher Curl", primaryMuscle: .biceps, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Cable Curl", primaryMuscle: .biceps, equipment: .cable, category: .isolation),
        ExerciseTemplate(name: "Tricep Dips", primaryMuscle: .triceps, equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Tricep Pushdown", primaryMuscle: .triceps, equipment: .cable, category: .isolation),
        ExerciseTemplate(name: "Overhead Tricep Extension", primaryMuscle: .triceps, equipment: .dumbbell, category: .isolation),
        ExerciseTemplate(name: "Skull Crushers", primaryMuscle: .triceps, equipment: .barbell, category: .isolation),
        ExerciseTemplate(name: "Close Grip Bench Press", primaryMuscle: .triceps, secondaryMuscles: [.chest], equipment: .barbell, category: .compound),
        
        // CORE
        ExerciseTemplate(name: "Plank", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "Side Plank", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "Dead Bug", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "Hanging Knee Raise", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "Ab Wheel Rollout", primaryMuscle: .core, equipment: .other, category: .isolation),
        ExerciseTemplate(name: "Russian Twists", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "Mountain Climbers", primaryMuscle: .core, secondaryMuscles: [.shoulders], equipment: .bodyweight, category: .cardio),
        ExerciseTemplate(name: "Toes-to-Bar", primaryMuscle: .core, secondaryMuscles: [.shoulders], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Knees-to-Elbows", primaryMuscle: .core, secondaryMuscles: [.shoulders], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "V-ups", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "Hollow Holds", primaryMuscle: .core, equipment: .bodyweight, category: .isolation),
        ExerciseTemplate(name: "L-sit", primaryMuscle: .core, secondaryMuscles: [.shoulders], equipment: .bodyweight, category: .isolation),
        
        // CROSSFIT & FUNCTIONAL FITNESS
        ExerciseTemplate(name: "Kettlebell Swing", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings, .back, .core], equipment: .kettlebell, category: .compound, instructions: "Hip hinge movement, explosive hip drive"),
        ExerciseTemplate(name: "Kettlebell Goblet Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .core], equipment: .kettlebell, category: .compound),
        ExerciseTemplate(name: "Kettlebell Clean", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .back], equipment: .kettlebell, category: .compound),
        ExerciseTemplate(name: "Kettlebell Snatch", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .core], equipment: .kettlebell, category: .compound),
        ExerciseTemplate(name: "Turkish Get-Up", primaryMuscle: .fullBody, secondaryMuscles: [.core, .shoulders], equipment: .kettlebell, category: .compound),
        
        ExerciseTemplate(name: "Burpees", primaryMuscle: .fullBody, secondaryMuscles: [.chest, .core], equipment: .bodyweight, category: .cardio, instructions: "Full body conditioning exercise"),
        ExerciseTemplate(name: "Box Jumps", primaryMuscle: .legs, secondaryMuscles: [.glutes], equipment: .other, category: .compound, instructions: "Explosive lower body power"),
        ExerciseTemplate(name: "Wall Balls", primaryMuscle: .legs, secondaryMuscles: [.shoulders, .core], equipment: .other, category: .compound, instructions: "Squat + overhead throw"),
        ExerciseTemplate(name: "Thrusters", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .legs], equipment: .barbell, category: .compound, instructions: "Front squat + push press"),
        ExerciseTemplate(name: "Clean and Jerk", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .legs], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Snatch", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .back], equipment: .barbell, category: .compound),
        ExerciseTemplate(name: "Power Clean", primaryMuscle: .fullBody, secondaryMuscles: [.back, .shoulders], equipment: .barbell, category: .compound),
        
        ExerciseTemplate(name: "Rowing (Machine)", primaryMuscle: .cardio, secondaryMuscles: [.back, .legs], equipment: .machine, category: .cardio, instructions: "Full body cardio"),
        ExerciseTemplate(name: "Assault Bike", primaryMuscle: .cardio, secondaryMuscles: [.fullBody], equipment: .machine, category: .cardio),
        ExerciseTemplate(name: "Jump Rope", primaryMuscle: .cardio, secondaryMuscles: [.calves], equipment: .other, category: .cardio, instructions: "Single unders or double unders"),
        ExerciseTemplate(name: "Double Unders", primaryMuscle: .cardio, secondaryMuscles: [.calves, .shoulders], equipment: .other, category: .cardio),
        
        ExerciseTemplate(name: "Handstand Push-ups", primaryMuscle: .shoulders, secondaryMuscles: [.triceps, .core], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Handstand Hold", primaryMuscle: .shoulders, secondaryMuscles: [.core], equipment: .bodyweight, category: .isolation),
        
        ExerciseTemplate(name: "Ring Dips", primaryMuscle: .triceps, secondaryMuscles: [.chest, .shoulders], equipment: .other, category: .compound),
        ExerciseTemplate(name: "Ring Rows", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .other, category: .compound),
        ExerciseTemplate(name: "Muscle-ups", primaryMuscle: .fullBody, secondaryMuscles: [.back, .chest, .core], equipment: .other, category: .compound),
        ExerciseTemplate(name: "Chest-to-Bar Pull-ups", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Kipping Pull-ups", primaryMuscle: .back, secondaryMuscles: [.biceps, .core], equipment: .bodyweight, category: .compound),
        
        ExerciseTemplate(name: "Bear Crawl", primaryMuscle: .fullBody, secondaryMuscles: [.core, .shoulders], equipment: .bodyweight, category: .cardio),
        ExerciseTemplate(name: "Sled Push", primaryMuscle: .legs, secondaryMuscles: [.core], equipment: .other, category: .compound),
        ExerciseTemplate(name: "Sled Pull", primaryMuscle: .legs, secondaryMuscles: [.back], equipment: .other, category: .compound),
        ExerciseTemplate(name: "Farmer's Carry", primaryMuscle: .fullBody, secondaryMuscles: [.core, .shoulders], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Overhead Carry", primaryMuscle: .shoulders, secondaryMuscles: [.core], equipment: .dumbbell, category: .compound),
        
        ExerciseTemplate(name: "Devil Press", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .chest], equipment: .dumbbell, category: .compound, instructions: "Burpee + dumbbell snatch"),
        ExerciseTemplate(name: "Dumbbell Thruster", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .legs], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Dumbbell Snatch", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .back], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Dumbbell Clean and Press", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .legs], equipment: .dumbbell, category: .compound),
        ExerciseTemplate(name: "Man Makers", primaryMuscle: .fullBody, secondaryMuscles: [.chest, .back, .shoulders], equipment: .dumbbell, category: .compound, instructions: "Burpee + row + press"),
        
        ExerciseTemplate(name: "Battle Ropes", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .core], equipment: .other, category: .cardio),
        ExerciseTemplate(name: "Tire Flips", primaryMuscle: .fullBody, secondaryMuscles: [.legs, .back], equipment: .other, category: .compound),
        ExerciseTemplate(name: "Slam Ball", primaryMuscle: .fullBody, secondaryMuscles: [.core, .shoulders], equipment: .other, category: .compound),
        
        ExerciseTemplate(name: "Air Squats", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Pistol Squats", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .core], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Jump Squats", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], equipment: .bodyweight, category: .compound),
        ExerciseTemplate(name: "Walking Lunges", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], equipment: .bodyweight, category: .compound),
        
        ExerciseTemplate(name: "Band Pull-apart", primaryMuscle: .shoulders, secondaryMuscles: [.back], equipment: .band, category: .isolation),
        ExerciseTemplate(name: "Banded Good Mornings", primaryMuscle: .hamstrings, secondaryMuscles: [.glutes, .back], equipment: .band, category: .compound),
        ExerciseTemplate(name: "Band Assisted Pull-ups", primaryMuscle: .back, secondaryMuscles: [.biceps], equipment: .band, category: .compound),
        
        // YOGA & MOBILITY
        ExerciseTemplate(name: "Downward Dog", primaryMuscle: .core, equipment: .bodyweight, category: .flexibility),
        ExerciseTemplate(name: "Pigeon Pose", primaryMuscle: .glutes, equipment: .bodyweight, category: .flexibility),
        ExerciseTemplate(name: "Cat-Cow Stretch", primaryMuscle: .back, equipment: .bodyweight, category: .flexibility),
        ExerciseTemplate(name: "Foam Rolling", primaryMuscle: .fullBody, equipment: .other, category: .flexibility),
        ExerciseTemplate(name: "Child's Pose", primaryMuscle: .back, equipment: .bodyweight, category: .flexibility),
        ExerciseTemplate(name: "Hip Flexor Stretch", primaryMuscle: .legs, equipment: .bodyweight, category: .flexibility),
    ]
    
    static func search(query: String) -> [ExerciseTemplate] {
        guard !query.isEmpty else { return allExercises }
        return allExercises.filter { exercise in
            exercise.name.localizedCaseInsensitiveContains(query) ||
            exercise.primaryMuscle.rawValue.localizedCaseInsensitiveContains(query) ||
            exercise.equipment.rawValue.localizedCaseInsensitiveContains(query)
        }
    }
    
    static func byMuscle(_ muscle: MuscleGroup) -> [ExerciseTemplate] {
        allExercises.filter { $0.primaryMuscle == muscle || $0.secondaryMuscles.contains(muscle) }
    }
    
    static func byEquipment(_ equipment: EquipmentType) -> [ExerciseTemplate] {
        allExercises.filter { $0.equipment == equipment }
    }
}
