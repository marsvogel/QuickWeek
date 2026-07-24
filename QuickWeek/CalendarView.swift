import SwiftUI

struct CalendarView: View {
    @State private var displayedMonth: Date = Date()

    private let calendar = WeekCalculator.calendar
    private let weekdaySymbols = ["M", "T", "W", "T", "F", "S", "S"]
    private let firstWeekendSymbolIndex = 5
    private let weekNumberColumnWidth: CGFloat = 28
    private let dayColumnWidth: CGFloat = 32

    var body: some View {
        VStack(spacing: 12) {
            monthNavigationHeader
            weekdayHeaderRow
            calendarGrid

            Divider()
                .padding(.top, 4)

            todayButton
        }
        .padding(12)
        .frame(width: 280)
        .onAppear {
            displayedMonth = Date()
        }
    }

    // MARK: - Subviews

    private var monthNavigationHeader: some View {
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
    }

    private var weekdayHeaderRow: some View {
        HStack(spacing: 0) {
            Text("")
                .frame(width: weekNumberColumnWidth)

            ForEach(weekdaySymbols.indices, id: \.self) { index in
                Text(weekdaySymbols[index])
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(index >= firstWeekendSymbolIndex ? .secondary : .primary)
                    .frame(width: dayColumnWidth)
            }
        }
    }

    private var calendarGrid: some View {
        VStack(spacing: 4) {
            ForEach(weeksInMonth, id: \.self) { week in
                HStack(spacing: 0) {
                    Text("\(weekNumber(for: week.first ?? Date()))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: weekNumberColumnWidth)

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
                .background(currentWeekHighlight(for: week))
            }
        }
    }

    private func currentWeekHighlight(for week: [Date]) -> some View {
        Group {
            if week.contains(where: { isInCurrentWeek($0) && isInDisplayedMonth($0) }) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.accentColor.opacity(0.15))
                    .padding(.horizontal, weekNumberColumnWidth)
            }
        }
    }

    private var todayButton: some View {
        Button(action: goToToday) {
            Text("Today")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
        .padding(.bottom, 4)
        .disabled(calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month))
    }

    // MARK: - Computed Properties

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
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
