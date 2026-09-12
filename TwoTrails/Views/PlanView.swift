import SwiftUI

struct PlanView: View {
    private let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Your 12-week plan. Tue, Thu and Sat are gym days — the rest are for walking.")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)

                    weekGrid

                    sectionHeader("Him — recomposition")
                    ForEach(["A", "B", "C"], id: \.self) { v in
                        if let variant = Plan.him[v] {
                            PlanBlock(person: .him, variant: variant)
                        }
                    }

                    sectionHeader("Her — beginner strength")
                    ForEach(["A", "B", "C"], id: \.self) { v in
                        if let variant = Plan.her[v] {
                            PlanBlock(person: .her, variant: variant)
                        }
                    }
                }
                .padding(18)
            }
            .background(Theme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.heading(17))
            .foregroundStyle(Theme.ink)
    }

    private var weekGrid: some View {
        HStack(spacing: 5) {
            ForEach(1...7, id: \.self) { weekday in
                let kind = Plan.schedule[weekday] ?? .rest
                let isGym: Bool = { if case .gym = kind { return true } else { return false } }()
                VStack(spacing: 2) {
                    Text(dayNames[weekday - 1])
                    if case .gym(let v) = kind {
                        Text(v)
                    }
                }
                .font(.system(size: 11))
                .foregroundStyle(isGym ? Theme.him : Theme.inkSoft)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(isGym ? Theme.himSoft : Color.clear)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(isGym ? Theme.him : Theme.line, lineWidth: 1))
            }
        }
    }
}

private struct PlanBlock: View {
    let person: Person
    let variant: WorkoutVariant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(variant.label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.accent(for: person))

            VStack(spacing: 0) {
                ForEach(variant.exercises) { ex in
                    HStack {
                        Text(ex.name).font(.system(size: 13.5)).foregroundStyle(Theme.ink)
                        Spacer()
                        Text(ex.sets).font(.system(size: 13.5)).foregroundStyle(Theme.inkSoft)
                    }
                    .padding(.vertical, 5)
                    .overlay(Rectangle().frame(height: 1).foregroundStyle(Theme.line), alignment: .bottom)
                }
            }
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.line, lineWidth: 1))
    }
}

#Preview {
    PlanView()
}
