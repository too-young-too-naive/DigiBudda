import Foundation

/// Represents the user's language preference for the app UI.
/// `.followSystem` defers to the macOS system locale.
enum AppLanguage: String, CaseIterable, Identifiable {
    case followSystem        = "followSystem"
    case chinese             = "zh-Hans"
    case chineseTraditional  = "zh-Hant"
    case english             = "en"
    case japanese            = "ja"
    case korean              = "ko"

    var id: String { rawValue }

    /// Human-readable label shown in the language picker.
    var displayName: String {
        switch self {
        case .followSystem:       return "Follow System"
        case .chinese:            return "简体中文"
        case .chineseTraditional: return "繁體中文"
        case .english:            return "English"
        case .japanese:           return "日本語"
        case .korean:             return "한국어"
        }
    }

    /// Resolves `.followSystem` to a concrete language based on the user's
    /// macOS preferred-languages list.
    var resolved: AppLanguage {
        guard self == .followSystem else { return self }
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("zh") {
            if preferred.contains("Hant") || preferred.contains("TW") || preferred.contains("HK") {
                return .chineseTraditional
            }
            return .chinese
        }
        if preferred.hasPrefix("ja") { return .japanese }
        if preferred.hasPrefix("ko") { return .korean }
        return .english
    }
}
