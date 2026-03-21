import AppKit
import SwiftUI

@MainActor
final class WakeStatusItemController: NSObject {
    private enum UI {
        static let activeTooltip = "Wake ativo"
        static let inactiveTooltip = "Wake inativo"
        static let activeSymbol = "lightbulb.max.fill"
        static let inactiveSymbol = "lightbulb.slash.fill"
        static let iconSize = NSSize(width: 18, height: 18)
    }

    private let onToggleWake: () -> Void
    private let statusItem: NSStatusItem
    private let popover = NSPopover()
    private let makePopoverContent: () -> AnyView

    init(
        statusItem: NSStatusItem,
        makePopoverContent: @escaping () -> AnyView,
        onToggleWake: @escaping () -> Void
    ) {
        self.statusItem = statusItem
        self.makePopoverContent = makePopoverContent
        self.onToggleWake = onToggleWake

        super.init()
        configure()
    }

    func update(isActive: Bool) {
        let symbolName = isActive ? UI.activeSymbol : UI.inactiveSymbol
        let tooltip = isActive ? UI.activeTooltip : UI.inactiveTooltip

        if let image = makeStatusImage(symbolName: symbolName, accessibilityDescription: tooltip, iconSize: UI.iconSize) {
            statusItem.button?.image = image
        }

        statusItem.button?.toolTip = tooltip
    }

    private func configure() {
        guard let button = statusItem.button else { return }

        popover.behavior = .transient
        popover.contentSize = NSSize(width: 280, height: 190)
        popover.contentViewController = NSHostingController(rootView: makePopoverContent())

        button.imagePosition = .imageOnly
        button.toolTip = UI.inactiveTooltip
        button.target = self
        button.action = #selector(handleClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    @objc
    private func handleClick(_ sender: Any?) {
        guard let button = statusItem.button else {
            onToggleWake()
            return
        }

        guard let event = NSApp.currentEvent else {
            onToggleWake()
            return
        }

        if event.type == .rightMouseUp {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.contentViewController = NSHostingController(rootView: makePopoverContent())
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
            return
        }

        onToggleWake()
    }

    private func makeStatusImage(symbolName: String, accessibilityDescription: String, iconSize: NSSize) -> NSImage? {
        guard let symbol = NSImage(systemSymbolName: symbolName, accessibilityDescription: accessibilityDescription) else {
            return nil
        }

        let image = NSImage(size: iconSize)
        image.lockFocus()
        symbol.draw(in: NSRect(origin: .zero, size: iconSize))
        image.unlockFocus()
        image.isTemplate = true
        return image
    }
}
