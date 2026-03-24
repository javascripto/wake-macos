import Foundation
import WakeCore

@MainActor
func main() {
    runMenuStateChecks()
    runViewModelChecks()
    print("WakeChecks passed")
}

@MainActor
func runMenuStateChecks() {
    let active = WakeMenuState(isActive: true, isUserActivityEnabled: true)
    assert(active.tooltip == "Wake ativo")
    assert(active.subtitle == "O Mac está sendo mantido acordado.")
    assert(active.toggleTitle == "Desativar Wake")
    assert(active.userActivityTitle == "Manter atividade do usuário")
    assert(active.userActivityState == .on)

    let inactive = WakeMenuState(isActive: false, isUserActivityEnabled: false)
    assert(inactive.tooltip == "Wake inativo")
    assert(inactive.subtitle == "Ative para impedir repouso do sistema e da tela.")
    assert(inactive.toggleTitle == "Ativar Wake")
    assert(inactive.userActivityTitle == "Manter atividade do usuário")
    assert(inactive.userActivityState == .off)
}

@MainActor
func runViewModelChecks() {
    let controller = FakeWakeController()
    let viewModel = WakeViewModel(wakeController: controller)

    viewModel.toggleWake()
    assert(viewModel.isActive)
    assert(controller.events == ["activate(false)"])

    viewModel.toggleWake()
    assert(!viewModel.isActive)
    assert(controller.events == ["activate(false)", "deactivate"])

    viewModel.activate()
    viewModel.setUserActivityEnabled(true)
    assert(viewModel.isActive)
    assert(viewModel.isUserActivityEnabled)
    assert(controller.events == ["activate(false)", "deactivate", "activate(false)", "deactivate", "activate(true)"])
}

@MainActor
final class FakeWakeController: WakeControlling {
    var isActive = false
    var events: [String] = []

    func activate(reportUserActivity: Bool) {
        events.append("activate(\(reportUserActivity))")
        isActive = true
    }

    func deactivate() {
        events.append("deactivate")
        isActive = false
    }
}

main()
