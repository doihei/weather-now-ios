import CoreModels

// MARK: - AppSettings.Theme + DisplayName

public extension AppSettings.Theme {
    /// 設定画面のテーマピッカーに表示するローカライズ済み名称。
    var displayName: String {
        switch self {
        case .system: L10n.themeSystem
        case .light: L10n.themeLight
        case .dark: L10n.themeDark
        }
    }
}
