import CoreModels

// MARK: - AppSettings.TemperatureUnit + AccessibilityName

public extension AppSettings.TemperatureUnit {
    /// VoiceOver 読み上げ用のローカライズ済み単位語（例: "21度"）。
    var accessibilityUnitName: String {
        switch self {
        case .celsius: L10n.temperatureUnitCelsiusAccessibility
        case .fahrenheit: L10n.temperatureUnitFahrenheitAccessibility
        }
    }
}
