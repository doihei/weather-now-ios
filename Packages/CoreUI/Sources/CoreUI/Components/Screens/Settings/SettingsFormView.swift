import CoreModels
import SwiftUI

public struct SettingsFormView: View {
    @Binding var settings: AppSettings

    public init(settings: Binding<AppSettings>) {
        self._settings = settings
    }

    public var body: some View {
        List {
            Section(L10n.settingsUnitSection) {
                Picker(L10n.settingsTemperaturePicker, selection: $settings.temperatureUnit) {
                    ForEach(AppSettings.TemperatureUnit.allCases, id: \.self) { unit in
                        Text(unit.symbol).tag(unit)
                    }
                }
                Picker(L10n.settingsWindPicker, selection: $settings.windUnit) {
                    ForEach(AppSettings.WindUnit.allCases, id: \.self) { unit in
                        Text(unit.symbol).tag(unit)
                    }
                }
            }
            Section(L10n.settingsAppearanceSection) {
                Picker(L10n.settingsThemePicker, selection: $settings.theme) {
                    ForEach(AppSettings.Theme.allCases, id: \.self) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
            }
            Section(L10n.settingsInfoSection) {
                LabeledContent(L10n.settingsApiLabel, value: "Open-Meteo v1")
            }
        }
        .navigationTitle(L10n.settingsTitle)
    }
}
