import AppKit

public struct WakeMenuState {
    public let isActive: Bool
    public let isUserActivityEnabled: Bool

    public init(isActive: Bool, isUserActivityEnabled: Bool) {
        self.isActive = isActive
        self.isUserActivityEnabled = isUserActivityEnabled
    }

    public var tooltip: String {
        isActive ? "Wake ativo" : "Wake inativo"
    }

    public var subtitle: String {
        isActive
            ? "O Mac está sendo mantido acordado."
            : "Ative para impedir repouso do sistema e da tela."
    }

    public var toggleTitle: String {
        isActive ? "Desativar Wake" : "Ativar Wake"
    }

    public var userActivityTitle: String {
        "Manter atividade do usuário"
    }

    public var userActivityState: NSControl.StateValue {
        isUserActivityEnabled ? .on : .off
    }
}
