struct WakeMenuState {
    let isActive: Bool
    let isUserActivityEnabled: Bool

    var tooltip: String {
        isActive ? "Wake ativo" : "Wake inativo"
    }

    var subtitle: String {
        isActive
            ? "O Mac está sendo mantido acordado."
            : "Ative para impedir repouso do sistema e da tela."
    }

    var toggleTitle: String {
        isActive ? "Desativar Wake" : "Ativar Wake"
    }

    var userActivityTitle: String {
        "Manter atividade do usuário"
    }
}
