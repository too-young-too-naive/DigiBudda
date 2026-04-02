import Cocoa
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!

    private let knockManager = KnockManager.shared
    private let audioManager = AudioManager.shared
    private let languageManager = LanguageManager.shared

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard ensureSingleInstance() else {
            NSApplication.shared.terminate(nil)
            return
        }
        setupStatusItem()
        setupPopover()
    }

    /// Terminate immediately if another instance is already running.
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
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    // MARK: - Popover

    private func setupPopover() {
        let rootView = MenuBarPopover()
            .environmentObject(knockManager)
            .environmentObject(languageManager)

        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 360)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: rootView)
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
