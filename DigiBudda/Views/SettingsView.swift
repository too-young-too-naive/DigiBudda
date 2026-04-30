import SwiftUI

/// Settings window with shortcut recorder and volume slider.
struct SettingsView: View {
    @ObservedObject var shortcutManager = ShortcutManager.shared
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var languageManager = LanguageManager.shared

    @State private var isRecording = false

    private var lang: AppLanguage { languageManager.selectedLanguage }

    var body: some View {
        VStack(spacing: 20) {
            Text(L10n.settings(lang))
                .font(.system(size: 15, weight: .semibold, design: .rounded))

            // Shortcut section
            GroupBox(label: Text(L10n.shortcutSection(lang)).font(.system(size: 12, weight: .medium))) {
                VStack(spacing: 12) {
                    HStack {
                        Text(L10n.enableShortcut(lang))
                            .font(.system(size: 12))
                        Spacer()
                        Toggle("", isOn: $shortcutManager.isEnabled)
                            .toggleStyle(.switch)
                            .labelsHidden()
                    }

                    if shortcutManager.isEnabled {
                        HStack {
                            Text(L10n.currentShortcut(lang))
                                .font(.system(size: 12))
                            Spacer()
                            shortcutRecorderButton
                        }

                        Text(L10n.shortcutAccessibilityHint(lang))
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(8)
            }

            // Volume section
            GroupBox(label: Text(L10n.volumeSection(lang)).font(.system(size: 12, weight: .medium))) {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        Slider(value: $audioManager.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }

                    Button(L10n.testSound(lang)) {
                        audioManager.playKnockSound()
                    }
                    .font(.system(size: 11))
                    .buttonStyle(.bordered)
                }
                .padding(8)
            }

            Spacer()
        }
        .padding(20)
        .frame(width: 320, height: 300)
    }

    // MARK: - Shortcut Recorder

    private var shortcutRecorderButton: some View {
        Button {
            isRecording.toggle()
            if isRecording {
                shortcutManager.unregister()
            } else if shortcutManager.isEnabled {
                shortcutManager.register()
            }
        } label: {
            Text(isRecording ? L10n.pressKeys(lang) : shortcutManager.shortcutDisplayString)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .frame(minWidth: 80)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
        .buttonStyle(.bordered)
        .overlay(
            Group {
                if isRecording {
                    KeyRecorderOverlay { keyCode, modifiers in
                        shortcutManager.setShortcut(keyCode: keyCode, modifiers: modifiers)
                        isRecording = false
                    }
                }
            }
        )
    }
}

/// Invisible view that captures the next key combo when recording.
struct KeyRecorderOverlay: NSViewRepresentable {
    let onRecord: (UInt16, CGEventFlags) -> Void

    func makeNSView(context: Context) -> KeyRecorderNSView {
        let view = KeyRecorderNSView()
        view.onRecord = onRecord
        DispatchQueue.main.async { view.window?.makeFirstResponder(view) }
        return view
    }

    func updateNSView(_ nsView: KeyRecorderNSView, context: Context) {
        nsView.onRecord = onRecord
        DispatchQueue.main.async { nsView.window?.makeFirstResponder(nsView) }
    }
}

class KeyRecorderNSView: NSView {
    var onRecord: ((UInt16, CGEventFlags) -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        guard flags.contains(.command) || flags.contains(.control) || flags.contains(.option) else {
            return
        }
        var cgFlags = CGEventFlags()
        if flags.contains(.command) { cgFlags.insert(.maskCommand) }
        if flags.contains(.shift)   { cgFlags.insert(.maskShift) }
        if flags.contains(.option)  { cgFlags.insert(.maskAlternate) }
        if flags.contains(.control) { cgFlags.insert(.maskControl) }
        onRecord?(event.keyCode, cgFlags)
    }
}
