import CoreModels

// MARK: - AppSettings.WindUnit + AccessibilityName

public extension AppSettings.WindUnit {
    /// VoiceOver 読み上げ用のローカライズ済み単位語（例: "12キロメートル毎時"）。
    var accessibilityUnitName: String {
        switch self {
        case .kmh: L10n.windUnitKmhAccessibility
        case .mph: L10n.windUnitMphAccessibility
        }
    }
}
