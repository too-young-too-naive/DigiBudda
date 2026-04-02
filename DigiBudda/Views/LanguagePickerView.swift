import SwiftUI

/// Inline language picker displayed at the bottom of the popover.
struct LanguagePickerView: View {
    @EnvironmentObject var languageManager: LanguageManager

    private var lang: AppLanguage { languageManager.selectedLanguage }

    var body: some View {
        HStack {
            Text(L10n.language(lang))
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            Spacer()

            Picker("", selection: $languageManager.selectedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 155)
            .labelsHidden()
        }
        .padding(.horizontal, 24)
    }
}
