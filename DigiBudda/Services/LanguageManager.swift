import Foundation
import Combine

/// Manages the user's in-app language preference.
///
/// - `.followSystem` defers to the macOS system locale.
/// - Manual selection persists to UserDefaults and survives app relaunch.
/// - SwiftUI views observe `selectedLanguage` and re-render automatically.
final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    static let storageKey = "app_language"

    private let defaults: UserDefaults

    @Published var selectedLanguage: AppLanguage {
        didSet {
            defaults.set(selectedLanguage.rawValue, forKey: Self.storageKey)
        }
    }

    /// The concrete language after resolving "Follow System".
    var effective: AppLanguage {
        selectedLanguage.resolved
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let raw = defaults.string(forKey: Self.storageKey)
                  ?? AppLanguage.followSystem.rawValue
        self.selectedLanguage = AppLanguage(rawValue: raw) ?? .followSystem
    }
}
