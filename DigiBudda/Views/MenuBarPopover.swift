import SwiftUI

/// The main popover view shown when clicking the menu bar icon.
struct MenuBarPopover: View {
    @EnvironmentObject var knockManager: KnockManager
    @EnvironmentObject var languageManager: LanguageManager

    private var lang: AppLanguage { languageManager.selectedLanguage }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            countSection
            meritMessage
            knockButton
            Divider().padding(.top, 12)
            bottomControls
        }
        .frame(width: 272)
        .padding(.vertical, 8)
    }

    // MARK: - Subviews

    private var header: some View {
        Text(L10n.appTitle(lang))
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .padding(.vertical, 10)
    }

    private var countSection: some View {
        VStack(spacing: 4) {
            Text("\(knockManager.todayCount)")
                .font(.system(size: 54, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.orange, .yellow],
                                   startPoint: .top, endPoint: .bottom)
                )
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3), value: knockManager.todayCount)

            Text(L10n.todayKnocks(lang))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 14)
    }

    private var meritMessage: some View {
        Text(MessageGenerator.meritMessage(count: knockManager.todayCount, language: lang))
            .font(.system(size: 12))
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .frame(minHeight: 36)
    }

    private var knockButton: some View {
        Button {
            knockManager.knock()
            AudioManager.shared.playKnockSound()
        } label: {
            Text(L10n.knockButton(lang))
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 34)
        }
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    private var bottomControls: some View {
        HStack(spacing: 0) {
            Text(L10n.language(lang))
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            Picker("", selection: $languageManager.selectedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .scaleEffect(0.85, anchor: .leading)
            .frame(width: 100)

            Spacer()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Image(systemName: "power")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 6)
    }
}
