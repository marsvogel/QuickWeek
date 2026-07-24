import Foundation

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

enum WeekCalculator {
    static let daysPerWeek = 7

    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .autoupdatingCurrent
        return calendar
    }()

    static func isoWeekNumber(for date: Date, calendar: Calendar = WeekCalculator.calendar) -> Int {
        calendar.component(.weekOfYear, from: date)
    }

    static func menuBarTitle(for date: Date, calendar: Calendar = WeekCalculator.calendar) -> String {
        String(format: "CW%02d", isoWeekNumber(for: date, calendar: calendar))
    }

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
            for _ in 0..<daysPerWeek {
                week.append(cursor)
                cursor = calendar.date(byAdding: .day, value: 1, to: cursor) ?? cursor
            }
            weeks.append(week)
        }
        return weeks
    }

    static func isWeekend(_ date: Date, calendar: Calendar = WeekCalculator.calendar) -> Bool {
        let weekday = Weekday(rawValue: calendar.component(.weekday, from: date))
        return weekday == .saturday || weekday == .sunday
    }
}
