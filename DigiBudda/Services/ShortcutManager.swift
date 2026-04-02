import Cocoa

/// Registers a global keyboard shortcut (⌘⇧K by default) for knocking.
///
/// Uses `NSEvent` monitors which require Accessibility permission on macOS.
/// The key combo is stored as properties so customization can be added later.
final class ShortcutManager: ObservableObject {

    static let shared = ShortcutManager()

    /// Called on the main thread when the shortcut fires.
    var onKnock: (() -> Void)?

    // Default shortcut: ⌘⇧K  (keyCode 40 = 'k')
    var modifiers: NSEvent.ModifierFlags = [.command, .shift]
    var keyCode: UInt16 = 40

    private var globalMonitor: Any?
    private var localMonitor: Any?

    private init() {}

    /// Start listening for the global shortcut.
    func register() {
        unregister()

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        }
    }

    /// Stop listening.
    func unregister() {
        if let m = globalMonitor { NSEvent.removeMonitor(m); globalMonitor = nil }
        if let m = localMonitor  { NSEvent.removeMonitor(m); localMonitor = nil }
    }

    private func handleKeyEvent(_ event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        guard event.keyCode == keyCode, flags == modifiers else { return }
        DispatchQueue.main.async { [weak self] in
            self?.onKnock?()
        }
    }
}
