import Foundation

/// Centralized static UI strings.
/// All user-facing text flows through here so adding a new language
/// only requires extending these functions (and `AppLanguage`).
enum L10n {

    static func appTitle(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "DigiBudda · 赛博木鱼"
        case .chineseTraditional: return "DigiBudda · 賽博木魚"
        case .japanese:           return "DigiBudda · サイバー木魚"
        case .korean:             return "DigiBudda · 사이버 목어"
        default:                  return "DigiBudda"
        }
    }

    static func todayKnocks(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "今日敲击"
        case .chineseTraditional: return "今日敲擊"
        case .japanese:           return "今日の打数"
        case .korean:             return "오늘의 두드림"
        default:                  return "Today's Knocks"
        }
    }

    static func knockButton(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "🪷 敲木鱼"
        case .chineseTraditional: return "🪷 敲木魚"
        case .japanese:           return "🪷 木魚を叩く"
        case .korean:             return "🪷 목어 두드리기"
        default:                  return "🪷 Knock"
        }
    }

    static func language(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "语言"
        case .chineseTraditional: return "語言"
        case .japanese:           return "言語"
        case .korean:             return "언어"
        default:                  return "Language"
        }
    }

    static func quit(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "退出 DigiBudda"
        case .chineseTraditional: return "結束 DigiBudda"
        case .japanese:           return "DigiBudda を終了"
        case .korean:             return "DigiBudda 종료"
        default:                  return "Quit DigiBudda"
        }
    }

    static func meritGoal(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "每日目标：108"
        case .chineseTraditional: return "每日目標：108"
        case .japanese:           return "日課目標：108"
        case .korean:             return "일일 목표: 108"
        default:                  return "Daily goal: 108"
        }
    }
}
