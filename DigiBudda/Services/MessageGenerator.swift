import Foundation

/// Generates playful merit messages based on today's knock count.
struct MessageGenerator {

    static func meritMessage(count: Int, language: AppLanguage) -> String {
        switch language.resolved {
        case .chinese:            return chineseMessage(count: count)
        case .chineseTraditional: return chineseTraditionalMessage(count: count)
        case .japanese:           return japaneseMessage(count: count)
        case .korean:             return koreanMessage(count: count)
        default:                  return englishMessage(count: count)
        }
    }

    // MARK: - Chinese

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

    // MARK: - Traditional Chinese

    private static func chineseTraditionalMessage(count: Int) -> String {
        let pool = [
            "今天功德已攢 \(count) 下，善哉善哉 🙏",
            "心誠則靈，已輕敲 \(count) 次 🪷",
            "今日修行進度：\(count) / 108 🧘",
            "木魚聲聲，功德 +\(count) 📿",
            "佛祖已讀，已敲 \(count) 下 ✅",
            "賽博修行中… 已攢功德 \(count) 點 🤖",
            "敲滿 108 下可原地飛升 🚀 當前：\(count)",
            "功德存入區塊鏈… \(count) 已確認 ⛓️",
        ]
        return pool[abs(count) % pool.count]
    }

    // MARK: - English

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

    // MARK: - Japanese

    private static func japaneseMessage(count: Int) -> String {
        let pool = [
            "本日の功徳：\(count) 回、南無阿弥陀仏 🙏",
            "心を込めて \(count) 回叩きました 🪷",
            "修行の進捗：\(count) / 108 🧘",
            "木魚ポクポク、功徳 +\(count) 📿",
            "仏様が \(count) 回の打を見守っています ✅",
            "サイバー修行中… 功徳 \(count) pt 獲得 🤖",
            "108 回叩くと即身成仏 🚀 現在：\(count)",
            "功徳をブロックチェーンに保存… \(count) 確認済 ⛓️",
        ]
        return pool[abs(count) % pool.count]
    }

    // MARK: - Korean

    private static func koreanMessage(count: Int) -> String {
        let pool = [
            "오늘의 공덕: \(count) 번, 나무아미타불 🙏",
            "정성껏 \(count) 번 두드렸습니다 🪷",
            "수행 진행률: \(count) / 108 🧘",
            "목어 통통, 공덕 +\(count) 📿",
            "부처님이 \(count) 번의 두드림을 보셨습니다 ✅",
            "사이버 수행 중… 공덕 \(count) 포인트 획득 🤖",
            "108 번 두드리면 즉신성불 🚀 현재: \(count)",
            "공덕을 블록체인에 저장… \(count) 확인됨 ⛓️",
        ]
        return pool[abs(count) % pool.count]
    }
}
