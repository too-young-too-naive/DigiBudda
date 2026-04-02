import Foundation

/// Manages the user's in-app language preference.
///
/// - `.followSystem` defers to the macOS system locale.
/// - Manual selection persists to UserDefaults and survives app relaunch.
/// - SwiftUI views observe `selectedLanguage` and re-render automatically.
final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    private static let storageKey = "app_language"

    @Published var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Self.storageKey)
        }
    }

    /// The concrete language after resolving "Follow System".
    var effective: AppLanguage {
        selectedLanguage.resolved
    }

    private init() {
        let raw = UserDefaults.standard.string(forKey: Self.storageKey)
                  ?? AppLanguage.followSystem.rawValue
        self.selectedLanguage = AppLanguage(rawValue: raw) ?? .followSystem
    }
}
