import AppKit
import Combine
import SwiftUI

@MainActor
final class WakeAppDelegate: NSObject, NSApplicationDelegate {
    private let viewModel = WakeViewModel()
    private var statusItemController: WakeStatusItemController?
    private var isActiveCancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItemController = WakeStatusItemController(
            statusItem: statusItem,
            makePopoverContent: { [viewModel] in
                AnyView(WakeMenuBarView(model: viewModel))
            },
            onToggleWake: { [viewModel] in
                viewModel.toggleWake()
            }
        )

        isActiveCancellable = viewModel.$isActive.sink { [weak self] isActive in
            self?.statusItemController?.update(isActive: isActive)
        }

        statusItemController?.update(isActive: viewModel.isActive)
    }

    func applicationWillTerminate(_ notification: Notification) {
        viewModel.deactivate()
    }
}
