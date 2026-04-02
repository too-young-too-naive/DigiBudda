import Foundation

/// Represents the user's language preference for the app UI.
/// `.followSystem` defers to the macOS system locale.
enum AppLanguage: String, CaseIterable, Identifiable {
    case followSystem = "followSystem"
    case chinese      = "zh-Hans"
    case english      = "en"

    var id: String { rawValue }

    /// Human-readable label shown in the language picker.
    var displayName: String {
        switch self {
        case .followSystem: return "Follow System"
        case .chinese:      return "简体中文"
        case .english:      return "English"
        }
    }

    /// Resolves `.followSystem` to a concrete language based on the user's
    /// macOS preferred-languages list.
    var resolved: AppLanguage {
        guard self == .followSystem else { return self }
        let preferred = Locale.preferredLanguages.first ?? "en"
        return preferred.hasPrefix("zh") ? .chinese : .english
    }
}
