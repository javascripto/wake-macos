import SwiftUI

@main
struct WakeApp: App {
    @NSApplicationDelegateAdaptor(WakeAppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
