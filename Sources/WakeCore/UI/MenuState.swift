import AppKit

public struct WakeMenuState {
    public let isActive: Bool
    public let isUserActivityEnabled: Bool
    public let startsActive: Bool
    public let launchesAtLogin: Bool

    public init(isActive: Bool, isUserActivityEnabled: Bool, startsActive: Bool, launchesAtLogin: Bool) {
        self.isActive = isActive
        self.isUserActivityEnabled = isUserActivityEnabled
        self.startsActive = startsActive
        self.launchesAtLogin = launchesAtLogin
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

    public var startsActiveTitle: String {
        "Iniciar app ativo"
    }

    public var startsActiveState: NSControl.StateValue {
        startsActive ? .on : .off
    }

    public var launchesAtLoginTitle: String {
        "Iniciar com o macOS"
    }

    public var launchesAtLoginState: NSControl.StateValue {
        launchesAtLogin ? .on : .off
    }
}
