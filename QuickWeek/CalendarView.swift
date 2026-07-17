import SwiftUI

struct CalendarView: View {
    @State private var displayedMonth: Date = Date()

    private let calendar = WeekCalculator.calendar
    private let weekdaySymbols = ["M", "D", "M", "D", "F", "S", "S"]

    var body: some View {
        VStack(spacing: 12) {
            // Month navigation header
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)

                Spacer()

                Text(monthYearString)
                    .font(.headline)

                Spacer()

                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)

            // Weekday headers with week number column
            HStack(spacing: 0) {
                // Empty space for week number column
                Text("")
                    .frame(width: 28)

                ForEach(weekdaySymbols.indices, id: \.self) { index in
                    Text(weekdaySymbols[index])
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(index >= 5 ? .secondary : .primary)
                        .frame(width: 32)
                }
            }

            // Calendar grid
            let weeks = weeksInMonth
            VStack(spacing: 4) {
                ForEach(weeks, id: \.self) { week in
                    HStack(spacing: 0) {
                        // Week number
                        Text("\(weekNumber(for: week.first ?? Date()))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 28)

                        // Days
                        ForEach(week, id: \.self) { date in
                            DayCell(
                                date: date,
                                isCurrentMonth: isInDisplayedMonth(date),
                                isToday: isToday(date),
                                isInCurrentWeek: isInCurrentWeek(date),
                                isWeekend: isWeekend(date)
                            )
                        }
                    }
                    .background(
                        Group {
                            if week.contains(where: { isInCurrentWeek($0) && isInDisplayedMonth($0) }) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.accentColor.opacity(0.15))
                                    .padding(.horizontal, 28)
                            }
                        }
                    )
                }
            }

            // Today button
            Divider()
                .padding(.top, 4)

            Button(action: goToToday) {
                Text("Heute")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            .padding(.bottom, 4)
            .disabled(calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month))
        }
        .padding(12)
        .frame(width: 280)
        .onAppear {
            displayedMonth = Date()
        }
    }

    // MARK: - Computed Properties

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }

    private var weeksInMonth: [[Date]] {
        WeekCalculator.weeks(inMonthOf: displayedMonth, calendar: calendar)
    }

    // MARK: - Helper Methods

    private func weekNumber(for date: Date) -> Int {
        WeekCalculator.isoWeekNumber(for: date, calendar: calendar)
    }

    private func isInDisplayedMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    private func isInCurrentWeek(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }

    private func isWeekend(_ date: Date) -> Bool {
        WeekCalculator.isWeekend(date, calendar: calendar)
    }

    private func previousMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
    }

    private func nextMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
    }

    private func goToToday() {
        displayedMonth = Date()
    }
}

struct DayCell: View {
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    let isInCurrentWeek: Bool
    let isWeekend: Bool

    private let calendar = WeekCalculator.calendar

    var body: some View {
        let day = calendar.component(.day, from: date)

        ZStack {
            if isToday {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 26, height: 26)
            }

            Text("\(day)")
                .font(.system(size: 13))
                .foregroundColor(dayColor)
        }
        .frame(width: 32, height: 28)
    }

    private var dayColor: Color {
        if isToday {
            return .white
        } else if !isCurrentMonth {
            return .secondary.opacity(0.5)
        } else if isWeekend {
            return .secondary
        } else {
            return .primary
        }
    }
}

#Preview {
    CalendarView()
}
