import Combine
import Foundation
import Darwin

@MainActor
final class WakeViewModel: ObservableObject {
    @Published private(set) var isActive = false
    @Published var isUserActivityEnabled = false

    private let wakeController = WakeController()

    func toggleWake() {
        isActive ? deactivate() : activate()
    }

    func toggleUserActivity() {
        isUserActivityEnabled.toggle()

        if isActive {
            refreshActivation(reportUserActivity: isUserActivityEnabled)
        }
    }

    func activate() {
        wakeController.activate(reportUserActivity: isUserActivityEnabled)
        isActive = wakeController.isActive
    }

    func refreshActivation(reportUserActivity: Bool) {
        if !isActive { return }
        wakeController.deactivate()
        wakeController.activate(reportUserActivity: reportUserActivity)
        isActive = wakeController.isActive
    }

    func deactivate() {
        wakeController.deactivate()
        isActive = wakeController.isActive
    }

    func quit() {
        deactivate()
        Darwin.exit(0)
    }
}
