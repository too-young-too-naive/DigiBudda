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
        VStack(spacing: 8) {
            LanguagePickerView()

            Button(L10n.quit(lang)) {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .foregroundColor(.secondary)
            .padding(.bottom, 4)
        }
        .padding(.top, 10)
    }
}
