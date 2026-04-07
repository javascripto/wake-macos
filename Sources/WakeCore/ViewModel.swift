import Combine
import Foundation
import Darwin

@MainActor
public protocol WakeControlling {
    var isActive: Bool { get }
    func activate(reportUserActivity: Bool)
    func deactivate()
}

extension WakeController: WakeControlling {}

@MainActor
public final class WakeViewModel: ObservableObject {
    @Published public private(set) var isActive = false
    @Published public var isUserActivityEnabled = false
    @Published public private(set) var startsActive = false
    @Published public private(set) var launchesAtLogin = false

    private let wakeController: WakeControlling
    private let preferences: WakePreferencesManaging
    private let launchAtLoginController: LaunchAtLoginControlling

    init(
        wakeController: WakeControlling,
        preferences: WakePreferencesManaging = WakePreferences(),
        launchAtLoginController: LaunchAtLoginControlling = LaunchAtLoginController()
    ) {
        self.wakeController = wakeController
        self.preferences = preferences
        self.launchAtLoginController = launchAtLoginController
        startsActive = preferences.startsActive
        launchesAtLogin = launchAtLoginController.launchesAtLogin
    }

    public func toggleWake() {
        isActive ? deactivate() : activate()
    }

    public func setUserActivityEnabled(_ isEnabled: Bool) {
        guard isUserActivityEnabled != isEnabled else { return }
        isUserActivityEnabled = isEnabled

        if isActive {
            refreshActivation(reportUserActivity: isUserActivityEnabled)
        }
    }

    public func setStartsActive(_ isEnabled: Bool) {
        guard startsActive != isEnabled else { return }
        startsActive = isEnabled
        preferences.startsActive = isEnabled
    }

    public func setLaunchesAtLogin(_ isEnabled: Bool) {
        launchAtLoginController.setLaunchesAtLogin(isEnabled)
        launchesAtLogin = launchAtLoginController.launchesAtLogin
    }

    public func activate() {
        wakeController.activate(reportUserActivity: isUserActivityEnabled)
        isActive = wakeController.isActive
    }

    public func refreshActivation(reportUserActivity: Bool) {
        if !isActive { return }
        wakeController.deactivate()
        wakeController.activate(reportUserActivity: reportUserActivity)
        isActive = wakeController.isActive
    }

    public func deactivate() {
        wakeController.deactivate()
        isActive = wakeController.isActive
    }

    public func quit() {
        deactivate()
        Darwin.exit(0)
    }
}
