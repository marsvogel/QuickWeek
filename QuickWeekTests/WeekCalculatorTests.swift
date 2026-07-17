import XCTest
@testable import QuickWeek

final class WeekCalculatorTests: XCTestCase {
    /// An ISO-8601 calendar pinned to UTC so the assertions are independent of the
    /// machine's time zone (CI runs in UTC, a developer's Mac usually does not).
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12 // Midday keeps the date clear of any DST/midnight boundary.
        return calendar.date(from: components)!
    }

    func testISOWeekNumberForKnownDates() {
        XCTAssertEqual(WeekCalculator.isoWeekNumber(for: date(2026, 7, 17), calendar: calendar), 29)
        // 1 Jan 2026 is a Thursday, so it belongs to week 1.
        XCTAssertEqual(WeekCalculator.isoWeekNumber(for: date(2026, 1, 1), calendar: calendar), 1)
        // Monday 29 Dec 2025 already starts ISO week 1 of 2026.
        XCTAssertEqual(WeekCalculator.isoWeekNumber(for: date(2025, 12, 29), calendar: calendar), 1)
        // Sunday 28 Dec 2025 is still the last day of week 52 of 2025.
        XCTAssertEqual(WeekCalculator.isoWeekNumber(for: date(2025, 12, 28), calendar: calendar), 52)
    }

    func testISOWeekNumberHandlesWeek53Years() {
        // 2020 is a 53-week ISO year; Friday 1 Jan 2021 still belongs to week 53.
        XCTAssertEqual(WeekCalculator.isoWeekNumber(for: date(2020, 12, 31), calendar: calendar), 53)
        XCTAssertEqual(WeekCalculator.isoWeekNumber(for: date(2021, 1, 1), calendar: calendar), 53)
    }

    func testMenuBarTitleIsZeroPadded() {
        XCTAssertEqual(WeekCalculator.menuBarTitle(for: date(2026, 7, 17), calendar: calendar), "KW29")
        // Weeks below ten are padded to keep the menu-bar width stable.
        XCTAssertEqual(WeekCalculator.menuBarTitle(for: date(2026, 2, 23), calendar: calendar), "KW09")
    }

    func testWeeksInMonthShapeForJuly2026() {
        let weeks = WeekCalculator.weeks(inMonthOf: date(2026, 7, 15), calendar: calendar)

        XCTAssertEqual(weeks.count, 5)
        for week in weeks {
            XCTAssertEqual(week.count, 7)
            // Each row starts on a Monday (weekday 2 in Foundation's Sunday=1 numbering).
            XCTAssertEqual(calendar.component(.weekday, from: week[0]), 2)
        }

        // Every calendar day of July is present exactly once.
        let julyDays = weeks.flatMap { $0 }
            .filter { calendar.component(.month, from: $0) == 7 }
            .map { calendar.component(.day, from: $0) }
        XCTAssertEqual(Set(julyDays), Set(1...31))
    }

    func testIsWeekend() {
        XCTAssertTrue(WeekCalculator.isWeekend(date(2026, 7, 18), calendar: calendar))  // Saturday
        XCTAssertTrue(WeekCalculator.isWeekend(date(2026, 7, 19), calendar: calendar))  // Sunday
        XCTAssertFalse(WeekCalculator.isWeekend(date(2026, 7, 17), calendar: calendar)) // Friday
        XCTAssertFalse(WeekCalculator.isWeekend(date(2026, 7, 13), calendar: calendar)) // Monday
    }
}
