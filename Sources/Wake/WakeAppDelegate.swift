import AppKit
import Combine

@MainActor
final class WakeAppDelegate: NSObject, NSApplicationDelegate {
    private let viewModel = WakeViewModel()
    private var statusItemController: WakeStatusItemController?
    private var stateCancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItemController = WakeStatusItemController(
            statusItem: statusItem,
            onToggleWake: { [viewModel] in
                viewModel.toggleWake()
            },
            onToggleUserActivity: { [viewModel] in
                viewModel.toggleUserActivity()
            },
            onQuit: { [viewModel] in
                viewModel.quit()
            }
        )

        stateCancellable = Publishers.CombineLatest(viewModel.$isActive, viewModel.$isUserActivityEnabled)
            .sink { [weak self] isActive, isUserActivityEnabled in
                self?.statusItemController?.update(
                    isActive: isActive,
                    isUserActivityEnabled: isUserActivityEnabled
                )
            }
    }

    func applicationWillTerminate(_ notification: Notification) {
        viewModel.deactivate()
    }
}
