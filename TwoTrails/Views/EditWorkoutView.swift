import SwiftUI

struct EditWorkoutView: View {
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    
    let variantKey: String
    
    @State private var variant: WorkoutVariant
    @State private var showingAddExercise = false
    @State private var editingExercise: ExerciseItem?
    
    private var currentPerson: Person {
        userManager.currentUser?.person ?? .him
    }
    
    init(variantKey: String, variant: WorkoutVariant) {
        self.variantKey = variantKey
        _variant = State(initialValue: variant)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                List {
                    Section {
                        ForEach(variant.exercises) { exercise in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(exercise.name)
                                        .font(.system(size: 15))
                                        .foregroundStyle(Theme.ink)
                                    Text(exercise.sets)
                                        .font(.system(size: 13))
                                        .foregroundStyle(Theme.inkSoft)
                                }
                                
                                Spacer()
                                
                                Button {
                                    editingExercise = exercise
                                } label: {
                                    Image(systemName: "pencil")
                                        .foregroundStyle(Theme.ink)
                                }
                                .buttonStyle(.plain)
                            }
                            .listRowBackground(Theme.card)
                        }
                        .onDelete(perform: deleteExercises)
                        .onMove(perform: moveExercises)
                    } header: {
                        Text("Exercises")
                            .foregroundStyle(Theme.ink)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(variant.label)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        saveChanges()
                        dismiss()
                    }
                    .foregroundStyle(Theme.ink)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddExercise = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Theme.ink)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                        .foregroundStyle(Theme.ink)
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                ExercisePickerView { template in
                    addExerciseFromTemplate(template)
                }
            }
            .sheet(item: $editingExercise) { exercise in
                EditExerciseView(exercise: exercise) { updated in
                    if let index = variant.exercises.firstIndex(where: { $0.id == exercise.id }) {
                        variant.exercises[index] = updated
                    }
                }
            }
        }
    }
    
    private func addExerciseFromTemplate(_ template: ExerciseTemplate) {
        let newExercise = ExerciseItem(
            id: "\(currentPerson.rawValue)_\(variantKey.lowercased())_\(UUID().uuidString)",
            name: template.name,
            sets: "3x10" // Default
        )
        variant.exercises.append(newExercise)
    }
    
    private func deleteExercises(at offsets: IndexSet) {
        variant.exercises.remove(atOffsets: offsets)
    }
    
    private func moveExercises(from source: IndexSet, to destination: Int) {
        variant.exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    private func saveChanges() {
        planStore.updateVariant(variant, key: variantKey, for: currentPerson)
    }
}

// MARK: - Exercise Picker

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (ExerciseTemplate) -> Void
    
    @State private var searchText = ""
    @State private var selectedMuscle: MuscleGroup?
    @State private var selectedEquipment: EquipmentType?
    @State private var showFilters = false
    
    private var filteredExercises: [ExerciseTemplate] {
        var results = ExerciseLibrary.allExercises
        
        // Filter by search
        if !searchText.isEmpty {
            results = ExerciseLibrary.search(query: searchText)
        }
        
        // Filter by muscle
        if let muscle = selectedMuscle {
            results = results.filter { $0.primaryMuscle == muscle || $0.secondaryMuscles.contains(muscle) }
        }
        
        // Filter by equipment
        if let equipment = selectedEquipment {
            results = results.filter { $0.equipment == equipment }
        }
        
        return results
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Theme.inkSoft)
                        TextField("Search exercises...", text: $searchText)
                            .foregroundStyle(Theme.ink)
                            .tint(Theme.ink)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Theme.inkSoft)
                            }
                        }
                    }
                    .padding(12)
                    .background(Theme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.line, lineWidth: 1)
                    )
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    
                    // Filter chips
                    if showFilters {
                        FilterChipsView(
                            selectedMuscle: $selectedMuscle,
                            selectedEquipment: $selectedEquipment
                        )
                        .padding(.horizontal, 18)
                        .padding(.bottom, 12)
                    }
                    
                    // Results
                    List {
                        Section {
                            ForEach(filteredExercises) { exercise in
                                ExerciseRowView(exercise: exercise)
                                    .listRowBackground(Theme.card)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        onSelect(exercise)
                                        dismiss()
                                    }
                            }
                        } header: {
                            HStack {
                                Text("\(filteredExercises.count) exercises")
                                    .foregroundStyle(Theme.inkSoft)
                                    .font(.system(size: 13))
                                Spacer()
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.ink)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showFilters.toggle()
                    } label: {
                        Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .foregroundStyle(Theme.ink)
                    }
                }
            }
        }
    }
}

struct ExerciseRowView: View {
    let exercise: ExerciseTemplate
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon based on equipment
            ZStack {
                Circle()
                    .fill(muscleColor(for: exercise.primaryMuscle).opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: equipmentIcon(for: exercise.equipment))
                    .font(.system(size: 18))
                    .foregroundStyle(muscleColor(for: exercise.primaryMuscle))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.ink)
                
                HStack(spacing: 8) {
                    // Primary muscle
                    Text(exercise.primaryMuscle.rawValue)
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(muscleColor(for: exercise.primaryMuscle))
                        .clipShape(Capsule())
                    
                    // Equipment
                    Text(exercise.equipment.rawValue)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.inkSoft)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Theme.line.opacity(0.5))
                        .clipShape(Capsule())
                    
                    // Category
                    Text(exercise.category.rawValue)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.inkSoft)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func muscleColor(for muscle: MuscleGroup) -> Color {
        switch muscle {
        case .chest: return Color(hex: "E74C3C")
        case .back: return Color(hex: "3498DB")
        case .shoulders: return Color(hex: "F39C12")
        case .biceps, .triceps: return Color(hex: "9B59B6")
        case .legs, .quadriceps, .hamstrings, .glutes, .calves: return Color(hex: "27AE60")
        case .core: return Color(hex: "E67E22")
        case .fullBody: return Color(hex: "34495E")
        case .cardio: return Color(hex: "1ABC9C")
        }
    }
    
    private func equipmentIcon(for equipment: EquipmentType) -> String {
        switch equipment {
        case .barbell: return "figure.strengthtraining.traditional"
        case .dumbbell: return "dumbbell.fill"
        case .cable: return "arrow.triangle.pull"
        case .machine: return "gearshape.fill"
        case .bodyweight: return "figure.walk"
        case .kettlebell: return "figure.strengthtraining.functional"
        case .band: return "arrow.left.and.right"
        case .other: return "questionmark.circle"
        }
    }
}

struct FilterChipsView: View {
    @Binding var selectedMuscle: MuscleGroup?
    @Binding var selectedEquipment: EquipmentType?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Muscle groups
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All Muscles",
                        isSelected: selectedMuscle == nil
                    ) {
                        selectedMuscle = nil
                    }
                    
                    ForEach(MuscleGroup.allCases, id: \.self) { muscle in
                        FilterChip(
                            title: muscle.rawValue,
                            isSelected: selectedMuscle == muscle
                        ) {
                            selectedMuscle = muscle
                        }
                    }
                }
            }
            
            // Equipment
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All Equipment",
                        isSelected: selectedEquipment == nil
                    ) {
                        selectedEquipment = nil
                    }
                    
                    ForEach(EquipmentType.allCases, id: \.self) { equipment in
                        FilterChip(
                            title: equipment.rawValue,
                            isSelected: selectedEquipment == equipment
                        ) {
                            selectedEquipment = equipment
                        }
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(isSelected ? .white : Theme.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Theme.ink : Theme.card)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Theme.line, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct EditExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: ExerciseItem
    let onSave: (ExerciseItem) -> Void
    
    @State private var name: String
    @State private var sets: String
    
    init(exercise: ExerciseItem, onSave: @escaping (ExerciseItem) -> Void) {
        self.exercise = exercise
        self.onSave = onSave
        _name = State(initialValue: exercise.name)
        _sets = State(initialValue: exercise.sets)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("Exercise name", text: $name)
                            .foregroundStyle(Theme.ink)
                        TextField("Sets & reps", text: $sets)
                            .foregroundStyle(Theme.ink)
                    }
                    .listRowBackground(Theme.card)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.ink)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = ExerciseItem(id: exercise.id, name: name, sets: sets)
                        onSave(updated)
                        dismiss()
                    }
                    .disabled(name.isEmpty || sets.isEmpty)
                    .foregroundStyle(Theme.ink)
                }
            }
        }
    }
}

#Preview {
    EditWorkoutView(
        variantKey: "A",
        variant: WorkoutVariant(label: "Full body A", exercises: [
            ExerciseItem(id: "1", name: "Squat", sets: "4x6-8"),
            ExerciseItem(id: "2", name: "Bench press", sets: "4x6-8")
        ])
    )
    .environmentObject(PlanStore())
    .environmentObject(UserManager())
}

#Preview("Exercise Picker") {
    ExercisePickerView { exercise in
        print("Selected: \(exercise.name)")
    }
}

