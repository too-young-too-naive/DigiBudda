import Cocoa
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var settingsWindow: NSWindow?

    private let knockManager = KnockManager.shared
    private let audioManager = AudioManager.shared
    private let shortcutManager = ShortcutManager.shared
    private let languageManager = LanguageManager.shared

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard ensureSingleInstance() else {
            NSApplication.shared.terminate(nil)
            return
        }
        setupStatusItem()
        setupPopover()
        setupRightClickMenu()
        setupShortcut()
    }

    private func ensureSingleInstance() -> Bool {
        let running = NSRunningApplication.runningApplications(
            withBundleIdentifier: Bundle.main.bundleIdentifier ?? ""
        )
        return running.count <= 1
    }

    // MARK: - Status Bar

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            let icon: NSImage? = {
                if let url = Bundle.main.url(forResource: "menubar_icon", withExtension: "png") {
                    return NSImage(contentsOf: url)
                }
                return nil
            }()
            if let icon {
                icon.isTemplate = true
                icon.size = NSSize(width: 26, height: 26)
                button.image = icon
            } else {
                button.image = NSImage(systemSymbolName: "leaf.fill",
                                       accessibilityDescription: "DigiBudda")
            }
            button.action = #selector(handleClick)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    // MARK: - Click Handling

    @objc private func handleClick() {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            showRightClickMenu()
        } else {
            togglePopover()
        }
    }

    // MARK: - Popover (Left Click)

    private func setupPopover() {
        let rootView = MenuBarPopover()
            .environmentObject(knockManager)
            .environmentObject(languageManager)

        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 360)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: rootView)
    }

    private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    // MARK: - Global Shortcut

    private func setupShortcut() {
        shortcutManager.onKnock = { [weak self] in
            self?.knockManager.knock()
            self?.audioManager.playKnockSound()
        }
        requestAccessibilityIfNeeded()
        shortcutManager.register()
    }

    /// Prompts the macOS Accessibility permission dialog on first launch.
    /// `AXIsProcessTrustedWithOptions` with `kAXTrustedCheckOptionPrompt`
    /// shows the system "allow Accessibility" alert if not yet granted.
    private func requestAccessibilityIfNeeded() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        let trusted = AXIsProcessTrustedWithOptions(options)
        if !trusted {
            print("[DigiBudda] Accessibility permission not yet granted — system prompt shown.")
        }
    }

    // MARK: - Right-Click Menu

    private var rightClickMenu: NSMenu!

    private func setupRightClickMenu() {
        rightClickMenu = NSMenu()

        let settingsItem = NSMenuItem(title: settingsTitle(), action: #selector(showSettings), keyEquivalent: ",")
        settingsItem.target = self
        rightClickMenu.addItem(settingsItem)

        let aboutItem = NSMenuItem(title: aboutTitle(), action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        rightClickMenu.addItem(aboutItem)

        rightClickMenu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: quitTitle(), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        rightClickMenu.addItem(quitItem)
    }

    private func showRightClickMenu() {
        rightClickMenu.items[0].title = settingsTitle()
        rightClickMenu.items[1].title = aboutTitle()
        rightClickMenu.items[3].title = quitTitle()

        if let button = statusItem.button {
            let p = NSPoint(x: 0, y: button.bounds.height + 5)
            rightClickMenu.popUp(positioning: nil, at: p, in: button)
        }
    }

    private func settingsTitle() -> String {
        L10n.settings(languageManager.selectedLanguage)
    }

    private func aboutTitle() -> String {
        let lang = languageManager.effective
        if lang == .chinese || lang == .chineseTraditional { return "关于 DigiBudda" }
        if lang == .japanese { return "DigiBudda について" }
        if lang == .korean { return "DigiBudda 정보" }
        return "About DigiBudda"
    }

    private func quitTitle() -> String {
        L10n.quit(languageManager.selectedLanguage)
    }

    // MARK: - Settings Window

    @objc private func showSettings() {
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = settingsTitle()
        window.styleMask = [.titled, .closable]
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        settingsWindow = window
    }

    // MARK: - About

    @objc private func showAbout() {
        let lang = languageManager.effective

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"

        let ghURL = "https://github.com/too-young-too-naive/DigiBudda"

        let message: String
        let info: String
        let ghLabel: String

        switch lang {
        case .chinese:
            message = "DigiBudda · 赛博木鱼"
            ghLabel = "GitHub 主页"
            info = """
            版本 \(version) (\(build))

            一款轻量有趣的 macOS 菜单栏木鱼 App。
            敲木鱼，攒功德。

            © 2026 DigiBudda
            License: MIT
            """
        case .chineseTraditional:
            message = "DigiBudda · 賽博木魚"
            ghLabel = "GitHub 主頁"
            info = """
            版本 \(version) (\(build))

            一款輕量有趣的 macOS 選單列木魚 App。
            敲木魚，攢功德。

            © 2026 DigiBudda
            License: MIT
            """
        case .japanese:
            message = "DigiBudda · サイバー木魚"
            ghLabel = "GitHub ページ"
            info = """
            バージョン \(version) (\(build))

            軽量で楽しい macOS メニューバー木魚アプリ。
            木魚を叩いて、功徳を積もう。

            © 2026 DigiBudda
            License: MIT
            """
        case .korean:
            message = "DigiBudda · 사이버 목어"
            ghLabel = "GitHub 페이지"
            info = """
            버전 \(version) (\(build))

            가볍고 재미있는 macOS 메뉴 바 목어 앱.
            목어를 두드려 공덕을 쌓으세요.

            © 2026 DigiBudda
            License: MIT
            """
        default:
            message = "DigiBudda"
            ghLabel = "GitHub"
            info = """
            Version \(version) (\(build))

            A lightweight, fun macOS menu bar wooden fish app.
            Knock the wooden fish, accumulate merit.

            © 2026 DigiBudda
            License: MIT
            """
        }

        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = info
        alert.alertStyle = .informational

        if let iconURL = Bundle.main.url(forResource: "menubar_icon", withExtension: "png"),
           let img = NSImage(contentsOf: iconURL) {
            img.size = NSSize(width: 64, height: 64)
            alert.icon = img
        }

        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: ghLabel)

        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            if let url = URL(string: ghURL) {
                NSWorkspace.shared.open(url)
            }
        }
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
