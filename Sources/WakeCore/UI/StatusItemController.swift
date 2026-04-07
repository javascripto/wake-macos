import AppKit

@MainActor
final class WakeStatusItemController: NSObject {
    private enum UI {
        static let iconSize = NSSize(width: 18, height: 18)
        static let quitTitle = "Sair"
    }

    private let onToggleWake: () -> Void
    private let onToggleUserActivity: () -> Void
    private let onToggleStartsActive: () -> Void
    private let onToggleLaunchAtLogin: () -> Void
    private let onQuit: () -> Void
    private let statusItem: NSStatusItem
    private let menu = NSMenu()
    private let titleItem = NSMenuItem()
    private let subtitleItem = NSMenuItem()
    private let toggleWakeItem = NSMenuItem()
    private let toggleUserActivityItem = NSMenuItem()
    private let toggleStartsActiveItem = NSMenuItem()
    private let toggleLaunchAtLoginItem = NSMenuItem()
    private let quitItem = NSMenuItem()

    init(
        statusItem: NSStatusItem,
        onToggleWake: @escaping () -> Void,
        onToggleUserActivity: @escaping () -> Void,
        onToggleStartsActive: @escaping () -> Void,
        onToggleLaunchAtLogin: @escaping () -> Void,
        onQuit: @escaping () -> Void
    ) {
        self.statusItem = statusItem
        self.onToggleWake = onToggleWake
        self.onToggleUserActivity = onToggleUserActivity
        self.onToggleStartsActive = onToggleStartsActive
        self.onToggleLaunchAtLogin = onToggleLaunchAtLogin
        self.onQuit = onQuit

        super.init()
        configure()
    }

    func update(menuState: WakeMenuState) {
        if let image = WakeStatusIconRenderer.makeImage(isActive: menuState.isActive, size: UI.iconSize, accessibilityDescription: menuState.tooltip) {
            statusItem.button?.image = image
        }

        statusItem.button?.toolTip = menuState.tooltip
        titleItem.title = menuState.tooltip
        subtitleItem.title = menuState.subtitle
        toggleWakeItem.title = menuState.toggleTitle
        toggleWakeItem.state = menuState.isActive ? .on : .off
        toggleUserActivityItem.title = menuState.userActivityTitle
        toggleUserActivityItem.state = menuState.userActivityState
        toggleStartsActiveItem.title = menuState.startsActiveTitle
        toggleStartsActiveItem.state = menuState.startsActiveState
        toggleLaunchAtLoginItem.title = menuState.launchesAtLoginTitle
        toggleLaunchAtLoginItem.state = menuState.launchesAtLoginState
    }

    private func configure() {
        guard let button = statusItem.button else { return }

        titleItem.isEnabled = false
        subtitleItem.isEnabled = false

        menu.autoenablesItems = false
        menu.items = [
            titleItem,
            subtitleItem,
            .separator(),
            menuItem(title: "", action: #selector(handleToggleWake), item: toggleWakeItem),
            menuItem(title: "", action: #selector(handleToggleUserActivity), item: toggleUserActivityItem),
            menuItem(title: "", action: #selector(handleToggleStartsActive), item: toggleStartsActiveItem),
            menuItem(title: "", action: #selector(handleToggleLaunchAtLogin), item: toggleLaunchAtLoginItem),
            .separator(),
            menuItem(title: UI.quitTitle, action: #selector(handleQuit), keyEquivalent: "q", item: quitItem),
        ]

        button.imagePosition = .imageOnly
        button.toolTip = WakeMenuState(isActive: false, isUserActivityEnabled: false, startsActive: false, launchesAtLogin: false).tooltip
        button.target = self
        button.action = #selector(handleStatusItemClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        update(menuState: WakeMenuState(isActive: false, isUserActivityEnabled: false, startsActive: false, launchesAtLogin: false))
    }

    @objc
    private func handleStatusItemClick(_ sender: Any?) {
        guard let event = NSApp.currentEvent else {
            onToggleWake()
            return
        }

        if event.type == .rightMouseUp {
            guard let button = statusItem.button else { return }
            button.highlight(true)
            let menuOrigin = NSPoint(x: 0, y: button.bounds.height + 4)
            menu.popUp(positioning: nil, at: menuOrigin, in: button)
            button.highlight(false)
            return
        }

        onToggleWake()
    }

    @objc
    private func handleToggleWake() {
        onToggleWake()
    }

    @objc
    private func handleToggleUserActivity() { onToggleUserActivity() }

    @objc
    private func handleToggleStartsActive() { onToggleStartsActive() }

    @objc
    private func handleToggleLaunchAtLogin() { onToggleLaunchAtLogin() }

    @objc
    private func handleQuit() { onQuit() }

    private func menuItem(
        title: String,
        action: Selector,
        keyEquivalent: String = "",
        item: NSMenuItem
    ) -> NSMenuItem {
        item.title = title
        item.keyEquivalent = keyEquivalent
        item.target = self
        item.action = action
        return item
    }
}
