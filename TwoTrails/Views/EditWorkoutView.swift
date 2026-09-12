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
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddExercise = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView { name, sets in
                    let newExercise = ExerciseItem(
                        id: "\(currentPerson.rawValue)_\(variantKey.lowercased())_\(UUID().uuidString)",
                        name: name,
                        sets: sets
                    )
                    variant.exercises.append(newExercise)
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

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (String, String) -> Void
    
    @State private var name = ""
    @State private var sets = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("Exercise name", text: $name)
                        TextField("Sets & reps (e.g., 3x10)", text: $sets)
                    }
                    .listRowBackground(Theme.card)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(name, sets)
                        dismiss()
                    }
                    .disabled(name.isEmpty || sets.isEmpty)
                }
            }
        }
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
                        TextField("Sets & reps", text: $sets)
                    }
                    .listRowBackground(Theme.card)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = ExerciseItem(id: exercise.id, name: name, sets: sets)
                        onSave(updated)
                        dismiss()
                    }
                    .disabled(name.isEmpty || sets.isEmpty)
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
