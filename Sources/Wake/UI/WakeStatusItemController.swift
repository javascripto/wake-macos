import AppKit

@MainActor
final class WakeStatusItemController: NSObject {
    private enum UI {
        static let iconSize = NSSize(width: 18, height: 18)
        static let quitTitle = "Sair"
        static let enableTitle = "Ativar Wake"
        static let disableTitle = "Desativar Wake"
        static let userActivityTitle = "Manter atividade do usuário"
    }

    private struct MenuContent {
        let title: String
        let subtitle: String
        let toggleTitle: String
    }

    private let onToggleWake: () -> Void
    private let onToggleUserActivity: () -> Void
    private let onQuit: () -> Void
    private let statusItem: NSStatusItem
    private let menu = NSMenu()
    private let titleItem = NSMenuItem()
    private let subtitleItem = NSMenuItem()
    private let toggleWakeItem = NSMenuItem()
    private let toggleUserActivityItem = NSMenuItem()
    private let quitItem = NSMenuItem()

    init(
        statusItem: NSStatusItem,
        onToggleWake: @escaping () -> Void,
        onToggleUserActivity: @escaping () -> Void,
        onQuit: @escaping () -> Void
    ) {
        self.statusItem = statusItem
        self.onToggleWake = onToggleWake
        self.onToggleUserActivity = onToggleUserActivity
        self.onQuit = onQuit

        super.init()
        configure()
    }

    func update(isActive: Bool, isUserActivityEnabled: Bool) {
        let content = menuContent(isActive: isActive)

        if let image = WakeStatusIconRenderer.makeImage(isActive: isActive, size: UI.iconSize, accessibilityDescription: content.title) {
            statusItem.button?.image = image
        }

        statusItem.button?.toolTip = content.title
        titleItem.title = content.title
        subtitleItem.title = content.subtitle
        toggleWakeItem.title = content.toggleTitle
        toggleWakeItem.state = isActive ? .on : .off
        toggleUserActivityItem.title = UI.userActivityTitle
        toggleUserActivityItem.state = isUserActivityEnabled ? .on : .off
    }

    private func configure() {
        guard let button = statusItem.button else { return }

        titleItem.isEnabled = false
        subtitleItem.isEnabled = false

        toggleWakeItem.target = self
        toggleWakeItem.action = #selector(handleToggleWake)

        toggleUserActivityItem.target = self
        toggleUserActivityItem.action = #selector(handleToggleUserActivity)

        quitItem.title = UI.quitTitle
        quitItem.keyEquivalent = "q"
        quitItem.target = self
        quitItem.action = #selector(handleQuit)

        menu.autoenablesItems = false
        menu.items = [
            titleItem,
            subtitleItem,
            .separator(),
            toggleWakeItem,
            toggleUserActivityItem,
            .separator(),
            quitItem,
        ]

        button.imagePosition = .imageOnly
        button.toolTip = menuContent(isActive: false).title
        button.target = self
        button.action = #selector(handleStatusItemClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        update(isActive: false, isUserActivityEnabled: false)
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
    private func handleToggleUserActivity() {
        onToggleUserActivity()
    }

    @objc
    private func handleQuit() {
        onQuit()
    }

    private func menuContent(isActive: Bool) -> MenuContent {
        if isActive {
            return MenuContent(
                title: "Wake ativo",
                subtitle: "O Mac está sendo mantido acordado.",
                toggleTitle: UI.disableTitle
            )
        }

        return MenuContent(
            title: "Wake inativo",
            subtitle: "Ative para impedir repouso do sistema e da tela.",
            toggleTitle: UI.enableTitle
        )
    }
}
