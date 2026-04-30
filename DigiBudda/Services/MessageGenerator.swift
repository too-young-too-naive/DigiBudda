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
            "佛说：敲 \(count) 下也改变不了你的KPI 💼",
            "已敲 \(count) 下，bug 依然在 🐛",
            "功德 \(count)，头发 +\(count) 🧑‍🦲",
            "敲木鱼能解决一切，除了房贷 🏠",
            "第 \(count) 下了，老板还没加薪 📉",
            "佛渡有缘人，但不渡甲方 \(count) 🙃",
            "功德攒了 \(count)，社保还是不够 💸",
            "已敲 \(count) 下，依然是打工人 🫠",
            "赛博超度进行中… 第 \(count) 位 👻",
            "木鱼敲烂了也上不了岸，第 \(count) 下 🏝️",
            "佛祖：已读不回。你：第 \(count) 敲 😶",
            "每敲一下多一根头发，当前 \(count) 🪮",
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
            "佛說：敲 \(count) 下也改變不了你的KPI 💼",
            "已敲 \(count) 下，bug 依然在 🐛",
            "功德 \(count)，頭髮 +\(count) 🧑‍🦲",
            "敲木魚能解決一切，除了房貸 🏠",
            "第 \(count) 下了，老闆還沒加薪 📉",
            "佛渡有緣人，但不渡甲方 \(count) 🙃",
            "功德攢了 \(count)，勞保還是不夠 💸",
            "已敲 \(count) 下，依然是打工仔 🫠",
            "賽博超度進行中… 第 \(count) 位 👻",
            "木魚敲爛了也上不了岸，第 \(count) 下 🏝️",
            "佛祖：已讀不回。你：第 \(count) 敲 😶",
            "每敲一下多一根頭髮，當前 \(count) 🪮",
        ]
        return pool[abs(count) % pool.count]
    }

    // MARK: - English

    private static func englishMessage(count: Int) -> String {
        let pool = [
            "Merit earned: \(count). Namaste 🙏",
            "\(count) knocks. Peace loading… 🪷",
            "Progress: \(count) / 108 🧘",
            "Wooden fish: merit +\(count) 📿",
            "Buddha saw \(count) knocks ✅",
            "Cyber-zen: \(count) merits 🤖",
            "108 to ascend 🚀 Now: \(count)",
            "On-chain merit: \(count) ⛓️",
            "\(count) knocks won't fix your bugs 🐛",
            "Merit \(count), hair +\(count) 🧑‍🦲",
            "Knocked \(count)x. Still no raise 📉",
            "Buddha left you on read ×\(count) 😶",
            "Therapy is $200/hr. This is free 🪷",
            "\(count) merits. Rent still due 💸",
            "Nirvana ETA: undefined. Knocked \(count) 🫠",
            "Knock \(count): existential dread -0% 🕳️",
            "Spiritual progress: \(count). Real: 0 👻",
            "HR said no. Buddha said maybe 🙃",
            "\(count) knocks. Still in meetings 📅",
            "Deploying karma… \(count) commits 🔥",
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
            "仏様が \(count) 回見守っています ✅",
            "サイバー修行中… 功徳 \(count) pt 🤖",
            "108 回で即身成仏 🚀 現在：\(count)",
            "功徳をチェーンに保存… \(count) 確認済 ⛓️",
            "\(count) 回叩いてもバグは消えない 🐛",
            "功徳 \(count)、髪の毛 +\(count) 🧑‍🦲",
            "\(count) 回叩いた。昇給なし 📉",
            "仏様：既読スルー ×\(count) 😶",
            "カウンセリングは高い。木魚は無料 🪷",
            "功徳 \(count)。家賃はまだ来る 💸",
            "涅槃まで：未定。現在 \(count) 回 🫠",
            "第 \(count) 打：虚無感 -0% 🕳️",
            "悟りの進捗：\(count)。現実：0 👻",
            "上司はダメと。仏は多分と 🙃",
            "\(count) 回。まだ会議中 📅",
            "カルマをデプロイ中… \(count) 回 🔥",
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
            "부처님이 \(count) 번 보셨습니다 ✅",
            "사이버 수행 중… 공덕 \(count) pt 🤖",
            "108 번이면 성불 🚀 현재: \(count)",
            "공덕 체인에 저장… \(count) 확인됨 ⛓️",
            "\(count) 번 쳐도 버그는 안 사라져 🐛",
            "공덕 \(count), 머리카락 +\(count) 🧑‍🦲",
            "\(count) 번 쳤는데 연봉 그대로 📉",
            "부처님: 읽씹 ×\(count) 😶",
            "상담은 비싸다. 목어는 무료 🪷",
            "공덕 \(count). 월세는 여전히 💸",
            "열반까지: 미정. 현재 \(count) 🫠",
            "\(count) 번째: 허무감 -0% 🕳️",
            "깨달음 진척: \(count). 현실: 0 👻",
            "팀장은 안 된대. 부처는 글쎄 🙃",
            "\(count) 번. 아직 회의 중 📅",
            "카르마 배포 중… \(count) 커밋 🔥",
        ]
        return pool[abs(count) % pool.count]
    }
}
