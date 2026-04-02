import Foundation

/// Tracks the daily wooden-fish knock count.
/// Persists to UserDefaults and auto-resets on a new calendar day.
final class KnockManager: ObservableObject {

    static let shared = KnockManager()

    private static let countKey = "knock_count"
    private static let dateKey  = "knock_date"

    @Published private(set) var todayCount: Int = 0

    private init() {
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
        let savedDate = UserDefaults.standard.string(forKey: Self.dateKey) ?? ""
        if savedDate == todayDateString() {
            todayCount = UserDefaults.standard.integer(forKey: Self.countKey)
        } else {
            todayCount = 0
            persist()
        }
    }

    private func resetIfNewDay() {
        let savedDate = UserDefaults.standard.string(forKey: Self.dateKey) ?? ""
        if savedDate != todayDateString() {
            todayCount = 0
        }
    }

    private func persist() {
        UserDefaults.standard.set(todayCount, forKey: Self.countKey)
        UserDefaults.standard.set(todayDateString(), forKey: Self.dateKey)
    }

    private func todayDateString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }
}
