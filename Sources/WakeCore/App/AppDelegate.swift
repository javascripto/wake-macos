import AppKit
import Combine

@MainActor
public final class AppDelegate: NSObject, NSApplicationDelegate {
    private let viewModel = WakeViewModel(wakeController: WakeController())
    private var statusItemController: WakeStatusItemController?
    private var stateCancellable: AnyCancellable?

    public override init() {}

    public func applicationDidFinishLaunching(_ notification: Notification) {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItemController = WakeStatusItemController(
            statusItem: statusItem,
            onToggleWake: { [viewModel] in
                viewModel.toggleWake()
            },
            onToggleUserActivity: { [viewModel] in
                viewModel.setUserActivityEnabled(!viewModel.isUserActivityEnabled)
            },
            onQuit: { [viewModel] in
                viewModel.quit()
            }
        )

        stateCancellable = Publishers.CombineLatest(viewModel.$isActive, viewModel.$isUserActivityEnabled)
            .map { WakeMenuState(isActive: $0, isUserActivityEnabled: $1) }
            .sink { [weak self] menuState in
                self?.statusItemController?.update(menuState: menuState)
            }
    }

    public func applicationWillTerminate(_ notification: Notification) {
        viewModel.deactivate()
    }
}
