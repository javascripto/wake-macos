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

    private let wakeController: WakeControlling

    public init(wakeController: WakeControlling) {
        self.wakeController = wakeController
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
