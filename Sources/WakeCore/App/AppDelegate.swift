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
            onToggleStartsActive: { [viewModel] in
                viewModel.setStartsActive(!viewModel.startsActive)
            },
            onToggleLaunchAtLogin: { [viewModel] in
                viewModel.setLaunchesAtLogin(!viewModel.launchesAtLogin)
            },
            onQuit: { [viewModel] in
                viewModel.quit()
            }
        )

        stateCancellable = Publishers.CombineLatest4(
            viewModel.$isActive,
            viewModel.$isUserActivityEnabled,
            viewModel.$startsActive,
            viewModel.$launchesAtLogin
        )
            .map { WakeMenuState(isActive: $0, isUserActivityEnabled: $1, startsActive: $2, launchesAtLogin: $3) }
            .sink { [weak self] menuState in
                self?.statusItemController?.update(menuState: menuState)
            }

        if viewModel.startsActive {
            viewModel.activate()
        }
    }

    public func applicationWillTerminate(_ notification: Notification) {
        viewModel.deactivate()
    }
}
