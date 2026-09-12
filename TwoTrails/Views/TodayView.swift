import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: TrackerStore
    private let today = Date()

    private var dayKind: DayKind { Plan.dayKind(for: today) }

    private var dateLabel: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: today)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    ForEach(Person.allCases) { person in
                        PersonCard(person: person, date: today, dayKind: dayKind)
                    }
                }
                .padding(18)
            }
            .background(Theme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(dateLabel)
                .font(.system(size: 13))
                .foregroundStyle(Theme.inkSoft)
            Text("Two Trails")
                .font(.heading(28))
                .foregroundStyle(Theme.ink)
            Text(dayKind.label)
                .font(.system(size: 13))
                .foregroundStyle(Theme.inkSoft)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Theme.line, lineWidth: 1)
                )
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    TodayView().environmentObject(TrackerStore())
}
