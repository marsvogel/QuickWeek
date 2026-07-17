import Foundation

/// Pure, testable calendar math shared by the menu-bar item and the popover.
///
/// Every calculation uses an ISO-8601 calendar: weeks start on Monday and week 1 is
/// the week containing the year's first Thursday. That matches how the calendar week
/// ("Kalenderwoche", KW) is counted in German-speaking and most European contexts —
/// which is exactly the number macOS does not show anywhere by default.
enum WeekCalculator {
    /// The ISO-8601 calendar used for every week calculation. Its time zone tracks the
    /// system (`autoupdatingCurrent`) so the week still updates correctly if the Mac's
    /// time zone changes at runtime — e.g. a laptop traveling across a week boundary.
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .autoupdatingCurrent
        return calendar
    }()

    /// The ISO-8601 calendar-week number (1...53) for the given date.
    static func isoWeekNumber(for date: Date, calendar: Calendar = WeekCalculator.calendar) -> Int {
        calendar.component(.weekOfYear, from: date)
    }

    /// The menu-bar title for the given date, e.g. `"KW29"` (zero-padded to two digits).
    static func menuBarTitle(for date: Date, calendar: Calendar = WeekCalculator.calendar) -> String {
        String(format: "KW%02d", isoWeekNumber(for: date, calendar: calendar))
    }

    /// The full weeks — each exactly seven days, Monday first — spanned by the month
    /// that contains `date`, including the leading and trailing days of adjacent months
    /// needed to fill the grid.
    static func weeks(inMonthOf date: Date, calendar: Calendar = WeekCalculator.calendar) -> [[Date]] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1) else {
            return []
        }

        var weeks: [[Date]] = []
        var cursor = firstWeek.start
        while cursor < lastWeek.end {
            var week: [Date] = []
            for _ in 0..<7 {
                week.append(cursor)
                cursor = calendar.date(byAdding: .day, value: 1, to: cursor) ?? cursor
            }
            weeks.append(week)
        }
        return weeks
    }

    /// Whether the date falls on Saturday or Sunday.
    static func isWeekend(_ date: Date, calendar: Calendar = WeekCalculator.calendar) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7 // Sunday = 1, Saturday = 7
    }
}
