import Foundation

/// Centralized static UI strings.
/// All user-facing text flows through here so adding a new language
/// only requires extending these functions (and `AppLanguage`).
enum L10n {

    static func appTitle(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "DigiBudda · 赛博木鱼" : "DigiBudda"
    }

    static func todayKnocks(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "今日敲击" : "Today's Knocks"
    }

    static func knockButton(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "🪷 敲木鱼" : "🪷 Knock"
    }

    static func language(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "语言" : "Language"
    }

    static func shortcutHint(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "快捷键：⌘⇧K" : "Shortcut: ⌘⇧K"
    }

    static func quit(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "退出 DigiBudda" : "Quit DigiBudda"
    }

    static func meritGoal(_ lang: AppLanguage) -> String {
        lang.resolved == .chinese ? "每日目标：108" : "Daily goal: 108"
    }
}
