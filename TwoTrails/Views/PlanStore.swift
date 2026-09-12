import Foundation
import Combine

final class PlanStore: ObservableObject {
    @Published var customPlans: [Person: [String: WorkoutVariant]] = [:]
    
    private let userDefaultsKey = "TwoTrails.CustomPlans"
    
    init() {
        loadCustomPlans()
    }
    
    // Get plan for a person (uses custom if available, otherwise defaults)
    func getPlan(for person: Person) -> [String: WorkoutVariant] {
        if let custom = customPlans[person], !custom.isEmpty {
            return custom
        }
        return Plan.defaultVariants(for: person)
    }
    
    // Update a specific variant for a person
    func updateVariant(_ variant: WorkoutVariant, key: String, for person: Person) {
        var personPlan = getPlan(for: person)
        personPlan[key] = variant
        customPlans[person] = personPlan
        saveCustomPlans()
    }
    
    // Update an exercise within a variant
    func updateExercise(_ exercise: ExerciseItem, in variantKey: String, for person: Person) {
        var personPlan = getPlan(for: person)
        guard var variant = personPlan[variantKey] else { return }
        
        if let index = variant.exercises.firstIndex(where: { $0.id == exercise.id }) {
            variant.exercises[index] = exercise
        }
        
        personPlan[variantKey] = variant
        customPlans[person] = personPlan
        saveCustomPlans()
    }
    
    // Add a new exercise to a variant
    func addExercise(name: String, sets: String, to variantKey: String, for person: Person) {
        var personPlan = getPlan(for: person)
        guard var variant = personPlan[variantKey] else { return }
        
        let newExercise = ExerciseItem(
            id: "\(person.rawValue)_\(variantKey.lowercased())_\(UUID().uuidString)",
            name: name,
            sets: sets
        )
        
        variant.exercises.append(newExercise)
        personPlan[variantKey] = variant
        customPlans[person] = personPlan
        saveCustomPlans()
    }
    
    // Remove an exercise from a variant
    func removeExercise(_ exerciseID: String, from variantKey: String, for person: Person) {
        var personPlan = getPlan(for: person)
        guard var variant = personPlan[variantKey] else { return }
        
        variant.exercises.removeAll { $0.id == exerciseID }
        personPlan[variantKey] = variant
        customPlans[person] = personPlan
        saveCustomPlans()
    }
    
    // Reset to default plan for a person
    func resetToDefault(for person: Person) {
        customPlans[person] = nil
        saveCustomPlans()
    }
    
    // Check if using custom plan
    func isUsingCustomPlan(for person: Person) -> Bool {
        return customPlans[person] != nil && !customPlans[person]!.isEmpty
    }
    
    // MARK: - Persistence
    
    private func saveCustomPlans() {
        let encoder = JSONEncoder()
        var encodableData: [String: [String: WorkoutVariant]] = [:]
        
        for (person, variants) in customPlans {
            encodableData[person.rawValue] = variants
        }
        
        if let encoded = try? encoder.encode(encodableData) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadCustomPlans() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        let decoder = JSONDecoder()
        
        if let decoded = try? decoder.decode([String: [String: WorkoutVariant]].self, from: data) {
            var result: [Person: [String: WorkoutVariant]] = [:]
            for (personRaw, variants) in decoded {
                if let person = Person(rawValue: personRaw) {
                    result[person] = variants
                }
            }
            customPlans = result
        }
    }
}

// Extension to Plan for default access
extension Plan {
    static func defaultVariants(for person: Person) -> [String: WorkoutVariant] {
        person == .him ? him : her
    }
}
