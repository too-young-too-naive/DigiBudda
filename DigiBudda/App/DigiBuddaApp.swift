import SwiftUI

@main
struct DigiBuddaApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No window — this is a menu-bar-only app.
        // An empty Settings scene satisfies the `App` protocol requirement.
        Settings {
            EmptyView()
        }
    }
}
