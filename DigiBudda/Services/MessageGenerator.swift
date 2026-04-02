import Foundation

/// Generates playful merit messages based on today's knock count.
/// Returns Chinese or English text depending on the active language.
struct MessageGenerator {

    static func meritMessage(count: Int, language: AppLanguage) -> String {
        switch language.resolved {
        case .chinese: return chineseMessage(count: count)
        default:       return englishMessage(count: count)
        }
    }

    // MARK: - Chinese Messages

    private static func chineseMessage(count: Int) -> String {
        let pool = [
            "今天功德已攒 \(count) 下，善哉善哉 🙏",
            "心诚则灵，已轻敲 \(count) 次 🪷",
            "今日修行进度：\(count) / 108 🧘",
            "木鱼声声，功德 +\(count) 📿",
            "佛祖已读，已敲 \(count) 下 ✅",
            "赛博修行中… 已攒功德 \(count) 点 🤖",
            "敲满 108 下可原地飞升 🚀 当前：\(count)",
            "功德存入区块链… \(count) 已确认 ⛓️",
        ]
        return pool[abs(count) % pool.count]
    }

    // MARK: - English Messages

    private static func englishMessage(count: Int) -> String {
        let pool = [
            "Today's merit: \(count) knocks. Namaste 🙏",
            "You knocked \(count) times. Inner peace loading… 🪷",
            "Daily progress: \(count) / 108 🧘",
            "Wooden fish says: merit +\(count) 📿",
            "Buddha has seen your \(count) knocks ✅",
            "Cyber-zen mode: \(count) merits earned 🤖",
            "Knock 108 times to ascend 🚀 Current: \(count)",
            "Merit saved to blockchain… \(count) confirmed ⛓️",
        ]
        return pool[abs(count) % pool.count]
    }
}
