import SwiftUI

struct WakeMenuBarView: View {
    @ObservedObject var model: WakeViewModel

    private var userActivityBinding: Binding<Bool> {
        Binding(
            get: { model.isUserActivityEnabled },
            set: { newValue in
                model.isUserActivityEnabled = newValue
                if model.isActive {
                    model.refreshActivation(reportUserActivity: newValue)
                }
            }
        )
    }

    private var title: String {
        model.isActive ? "Wake ativo" : "Wake inativo"
    }

    private var subtitle: String {
        model.isActive
            ? "O Mac está sendo mantido acordado."
            : "Ative para impedir repouso do sistema e da tela."
    }

    private var toggleTitle: String {
        model.isActive ? "Desativar Wake" : "Ativar Wake"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            menuSectionHeader

            Divider().padding(.vertical, 4)

            menuRow(
                title: toggleTitle,
                systemImage: "power",
                action: {
                    model.toggleWake()
                }
            )

            menuToggleRow(
                title: "Manter atividade do usuário",
                isOn: userActivityBinding
            )

            Divider().padding(.vertical, 4)

            menuRow(
                title: "Sair",
                systemImage: "xmark.circle",
                role: .destructive,
                action: {
                    model.quit()
                }
            )
            .keyboardShortcut("q")
        }
        .padding(6)
        .frame(width: 240)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var menuSectionHeader: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 6)
        .padding(.top, 4)
        .padding(.bottom, 2)
    }

    private func menuRow(
        title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role, action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .regular))
                    .frame(width: 14, alignment: .leading)

                Text(title)
                    .font(.system(size: 13))

                Spacer(minLength: 0)

                if model.isActive, title == toggleTitle {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(role == .destructive ? .red : .primary)
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
    }

    private func menuToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        Button {
            isOn.wrappedValue.toggle()
        } label: {
            HStack(spacing: 8) {
                Group {
                    if isOn.wrappedValue {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .semibold))
                    }
                }
                .frame(width: 14, alignment: .leading)

                Text(title)
                    .font(.system(size: 13))

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
    }
}
