import Cocoa
import Combine
import CoreGraphics

/// Registers a global keyboard shortcut for knocking.
///
/// Uses a `CGEvent` tap which works reliably for background / menu-bar-only apps.
/// Requires Accessibility permission in System Settings → Privacy & Security.
final class ShortcutManager: ObservableObject {

    static let shared = ShortcutManager()

    var onKnock: (() -> Void)?

    private static let keyCodeKey = "shortcut_keyCode"
    private static let modifiersKey = "shortcut_modifiers"
    private static let enabledKey = "shortcut_enabled"

    @Published var keyCode: UInt16 {
        didSet { UserDefaults.standard.set(Int(keyCode), forKey: Self.keyCodeKey) }
    }
    @Published var modifierFlags: UInt64 {
        didSet { UserDefaults.standard.set(modifierFlags, forKey: Self.modifiersKey) }
    }
    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: Self.enabledKey)
            if isEnabled { register() } else { unregister() }
        }
    }

    fileprivate var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    private init() {
        let savedCode = UserDefaults.standard.object(forKey: Self.keyCodeKey) as? Int
        let savedMods = UserDefaults.standard.object(forKey: Self.modifiersKey) as? UInt64
        let savedEnabled = UserDefaults.standard.object(forKey: Self.enabledKey) as? Bool

        self.keyCode = UInt16(savedCode ?? 40)  // default: 'k'
        self.modifierFlags = savedMods ?? (CGEventFlags.maskCommand.rawValue | CGEventFlags.maskShift.rawValue)
        self.isEnabled = savedEnabled ?? true
    }

    /// Human-readable label for the current shortcut.
    var shortcutDisplayString: String {
        var parts: [String] = []
        let flags = CGEventFlags(rawValue: modifierFlags)
        if flags.contains(.maskControl) { parts.append("⌃") }
        if flags.contains(.maskAlternate) { parts.append("⌥") }
        if flags.contains(.maskShift)   { parts.append("⇧") }
        if flags.contains(.maskCommand) { parts.append("⌘") }
        parts.append(Self.keyName(for: keyCode))
        return parts.joined()
    }

    /// Update the shortcut from a recorded key event.
    func setShortcut(keyCode: UInt16, modifiers: CGEventFlags) {
        self.keyCode = keyCode
        self.modifierFlags = modifiers.rawValue
        if isEnabled { register() }
    }

    func register() {
        unregister()
        guard isEnabled else { return }

        let mask: CGEventMask = (1 << CGEventType.keyDown.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: shortcutCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("[ShortcutManager] ⚠️ Cannot create event tap — grant Accessibility permission.")
            return
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    func unregister() {
        if let src = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), src, .commonModes)
            runLoopSource = nil
        }
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            eventTap = nil
        }
    }

    // MARK: - Key Name Mapping

    static func keyName(for code: UInt16) -> String {
        let map: [UInt16: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
            8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
            16: "Y", 17: "T", 18: "1", 19: "2", 20: "3", 21: "4", 22: "6",
            23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8", 29: "0",
            30: "]", 31: "O", 32: "U", 33: "[", 34: "I", 35: "P", 37: "L",
            38: "J", 39: "'", 40: "K", 41: ";", 42: "\\", 43: ",", 44: "/",
            45: "N", 46: "M", 47: ".", 49: "Space", 50: "`",
            36: "↩", 48: "⇥", 51: "⌫", 53: "⎋",
            122: "F1", 120: "F2", 99: "F3", 118: "F4", 96: "F5", 97: "F6",
            98: "F7", 100: "F8", 101: "F9", 109: "F10", 103: "F11", 111: "F12",
            123: "←", 124: "→", 125: "↓", 126: "↑",
        ]
        return map[code] ?? "?"
    }
}

private func shortcutCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let userInfo else { return Unmanaged.passRetained(event) }
    let manager = Unmanaged<ShortcutManager>.fromOpaque(userInfo).takeUnretainedValue()

    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = manager.eventTap {
            CGEvent.tapEnable(tap: tap, enable: true)
        }
        return Unmanaged.passRetained(event)
    }

    if type == .keyDown {
        let code = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
        let flags = event.flags
        let required = CGEventFlags(rawValue: manager.modifierFlags)

        if code == manager.keyCode,
           flags.contains(.maskCommand) == required.contains(.maskCommand),
           flags.contains(.maskShift) == required.contains(.maskShift),
           flags.contains(.maskAlternate) == required.contains(.maskAlternate),
           flags.contains(.maskControl) == required.contains(.maskControl) {
            DispatchQueue.main.async {
                manager.onKnock?()
            }
            return nil // consume the event so macOS doesn't play the system "bonk" sound
        }
    }

    return Unmanaged.passRetained(event)
}
