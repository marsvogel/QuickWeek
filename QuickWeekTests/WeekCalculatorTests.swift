import XCTest
@testable import QuickWeek

final class WeekCalculatorTests: XCTestCase {
    private let utcISOCalendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    private let middayHour = 12

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = middayHour
        return utcISOCalendar.date(from: components)!
    }

    private func isoWeekNumber(_ year: Int, _ month: Int, _ day: Int) -> Int {
        WeekCalculator.isoWeekNumber(for: date(year, month, day), calendar: utcISOCalendar)
    }

    func testISOWeekNumberOfAMidYearDate() {
        XCTAssertEqual(isoWeekNumber(2026, 7, 17), 29)
    }

    func testJanuaryFirstBelongsToWeekOneWhenItFallsOnAThursday() {
        XCTAssertEqual(isoWeekNumber(2026, 1, 1), 1)
    }

    func testMondayBeforeNewYearAlreadyStartsWeekOneOfTheComingYear() {
        XCTAssertEqual(isoWeekNumber(2025, 12, 29), 1)
    }

    func testSundayBeforeThatMondayIsStillTheLastWeekOfTheOldYear() {
        XCTAssertEqual(isoWeekNumber(2025, 12, 28), 52)
    }

    func testLastDayOfA53WeekYearIsWeek53() {
        XCTAssertEqual(isoWeekNumber(2020, 12, 31), 53)
    }

    func testJanuaryFirstFollowingA53WeekYearIsStillWeek53() {
        XCTAssertEqual(isoWeekNumber(2021, 1, 1), 53)
    }

    func testMenuBarTitleShowsTheWeekNumber() {
        XCTAssertEqual(
            WeekCalculator.menuBarTitle(for: date(2026, 7, 17), calendar: utcISOCalendar),
            "CW29"
        )
    }

    func testMenuBarTitlePadsWeeksBelowTenToTwoDigits() {
        XCTAssertEqual(
            WeekCalculator.menuBarTitle(for: date(2026, 2, 23), calendar: utcISOCalendar),
            "CW09"
        )
    }

    func testJuly2026SpansFiveWeekRows() {
        XCTAssertEqual(weeksInJuly2026().count, 5)
    }

    func testEveryWeekRowHoldsSevenDays() {
        for week in weeksInJuly2026() {
            XCTAssertEqual(week.count, WeekCalculator.daysPerWeek)
        }
    }

    func testEveryWeekRowStartsOnMonday() {
        for week in weeksInJuly2026() {
            XCTAssertEqual(utcISOCalendar.component(.weekday, from: week[0]), Weekday.monday.rawValue)
        }
    }

    func testWeekRowsCoverEveryDayOfTheMonthExactlyOnce() {
        let julyDays = weeksInJuly2026().flatMap { $0 }
            .filter { utcISOCalendar.component(.month, from: $0) == 7 }
            .map { utcISOCalendar.component(.day, from: $0) }

        XCTAssertEqual(Set(julyDays), Set(1...31))
        XCTAssertEqual(julyDays.count, 31)
    }

    func testSaturdayAndSundayAreWeekend() {
        XCTAssertTrue(WeekCalculator.isWeekend(date(2026, 7, 18), calendar: utcISOCalendar))
        XCTAssertTrue(WeekCalculator.isWeekend(date(2026, 7, 19), calendar: utcISOCalendar))
    }

    func testMondayThroughFridayAreNotWeekend() {
        XCTAssertFalse(WeekCalculator.isWeekend(date(2026, 7, 13), calendar: utcISOCalendar))
        XCTAssertFalse(WeekCalculator.isWeekend(date(2026, 7, 17), calendar: utcISOCalendar))
    }

    private func weeksInJuly2026() -> [[Date]] {
        WeekCalculator.weeks(inMonthOf: date(2026, 7, 15), calendar: utcISOCalendar)
    }
}
