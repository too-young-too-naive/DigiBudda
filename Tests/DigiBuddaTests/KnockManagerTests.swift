import XCTest
@testable import DigiBuddaCore

final class KnockManagerTests: XCTestCase {

    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "com.digibudda.tests.\(UUID().uuidString)")!
    }

    override func tearDown() {
        if let name = defaults.volatileDomainNames.first {
            defaults.removePersistentDomain(forName: name)
        }
        defaults = nil
        super.tearDown()
    }

    private func makeManager(date: Date = Date()) -> KnockManager {
        KnockManager(defaults: defaults, dateProvider: { date })
    }

    // MARK: - Initial state

    func testInitialCountIsZero() {
        let mgr = makeManager()
        XCTAssertEqual(mgr.todayCount, 0)
    }

    // MARK: - Knocking

    func testKnockIncrementsCount() {
        let mgr = makeManager()
        mgr.knock()
        XCTAssertEqual(mgr.todayCount, 1)
    }

    func testMultipleKnocks() {
        let mgr = makeManager()
        for _ in 0..<10 {
            mgr.knock()
        }
        XCTAssertEqual(mgr.todayCount, 10)
    }

    func testKnock108Times() {
        let mgr = makeManager()
        for _ in 0..<108 {
            mgr.knock()
        }
        XCTAssertEqual(mgr.todayCount, 108)
    }

    // MARK: - Persistence

    func testPersistenceAcrossInstances() {
        let now = Date()
        let mgr1 = KnockManager(defaults: defaults, dateProvider: { now })
        mgr1.knock()
        mgr1.knock()
        mgr1.knock()
        XCTAssertEqual(mgr1.todayCount, 3)

        let mgr2 = KnockManager(defaults: defaults, dateProvider: { now })
        XCTAssertEqual(mgr2.todayCount, 3, "New instance should restore persisted count")
    }

    func testPersistsToUserDefaults() {
        let now = Date()
        let mgr = KnockManager(defaults: defaults, dateProvider: { now })
        mgr.knock()
        mgr.knock()

        let stored = defaults.integer(forKey: KnockManager.countKey)
        XCTAssertEqual(stored, 2)

        let storedDate = defaults.string(forKey: KnockManager.dateKey)
        XCTAssertEqual(storedDate, mgr.todayDateString())
    }

    // MARK: - Daily reset

    func testDailyResetOnNewDay() {
        let today = Date()
        let mgr1 = KnockManager(defaults: defaults, dateProvider: { today })
        mgr1.knock()
        mgr1.knock()
        mgr1.knock()
        XCTAssertEqual(mgr1.todayCount, 3)

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let mgr2 = KnockManager(defaults: defaults, dateProvider: { tomorrow })
        XCTAssertEqual(mgr2.todayCount, 0, "Count should reset on a new day")
    }

    func testKnockAfterDayChangeResetsFirst() {
        let today = Date()
        let mgr = KnockManager(defaults: defaults, dateProvider: { today })
        mgr.knock()
        mgr.knock()
        XCTAssertEqual(mgr.todayCount, 2)

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let mgr2 = KnockManager(defaults: defaults, dateProvider: { tomorrow })
        mgr2.knock()
        XCTAssertEqual(mgr2.todayCount, 1, "First knock on new day should start from 1")
    }

    func testSameDayDoesNotReset() {
        let now = Date()
        let mgr1 = KnockManager(defaults: defaults, dateProvider: { now })
        mgr1.knock()
        mgr1.knock()

        let mgr2 = KnockManager(defaults: defaults, dateProvider: { now })
        XCTAssertEqual(mgr2.todayCount, 2, "Same day should not reset")
    }

    // MARK: - Date string

    func testTodayDateStringFormat() {
        let mgr = makeManager()
        let dateStr = mgr.todayDateString()
        let regex = try! NSRegularExpression(pattern: #"^\d{4}-\d{2}-\d{2}$"#)
        let range = NSRange(dateStr.startIndex..., in: dateStr)
        XCTAssertNotNil(regex.firstMatch(in: dateStr, range: range),
                        "Date string should be yyyy-MM-dd format, got: \(dateStr)")
    }
}
