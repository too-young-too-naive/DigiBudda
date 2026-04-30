import Foundation
import Combine

/// Tracks the daily wooden-fish knock count.
/// Persists to UserDefaults and auto-resets on a new calendar day.
final class KnockManager: ObservableObject {

    static let shared = KnockManager()

    static let countKey = "knock_count"
    static let dateKey  = "knock_date"

    @Published private(set) var todayCount: Int = 0

    private let defaults: UserDefaults
    private let dateProvider: () -> Date

    init(defaults: UserDefaults = .standard, dateProvider: @escaping () -> Date = { Date() }) {
        self.defaults = defaults
        self.dateProvider = dateProvider
        loadTodayCount()
    }

    /// Increment today's knock count by one.
    func knock() {
        resetIfNewDay()
        todayCount += 1
        persist()
    }

    // MARK: - Persistence

    private func loadTodayCount() {
        let savedDate = defaults.string(forKey: Self.dateKey) ?? ""
        if savedDate == todayDateString() {
            todayCount = defaults.integer(forKey: Self.countKey)
        } else {
            todayCount = 0
            persist()
        }
    }

    private func resetIfNewDay() {
        let savedDate = defaults.string(forKey: Self.dateKey) ?? ""
        if savedDate != todayDateString() {
            todayCount = 0
        }
    }

    private func persist() {
        defaults.set(todayCount, forKey: Self.countKey)
        defaults.set(todayDateString(), forKey: Self.dateKey)
    }

    func todayDateString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: dateProvider())
    }
}
