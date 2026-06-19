import CoreModels
import SwiftUI

// MARK: - TemperatureText

/// 摂氏値を設定された単位に変換して表示する共通コンポーネント。
public struct TemperatureText: View {
    let celsius: Double
    let unit: AppSettings.TemperatureUnit

    public init(celsius: Double, unit: AppSettings.TemperatureUnit) {
        self.celsius = celsius
        self.unit = unit
    }

    public var body: some View {
        Text(formatted)
            .accessibilityLabel(accessibilityLabel)
    }

    // 画面表示用: "21℃" / "70℉"（記号のまま）
    private var formatted: String {
        let value = unit.convert(celsius)
        return String(format: "%.0f%@", value, unit.symbol)
    }

    // VoiceOver読み上げ用: "21度" / "70華氏度"
    private var accessibilityLabel: String {
        let value = unit.convert(celsius)
        // 例: "21度" / "70華氏度"。L10nに読み上げ用の語を用意して引く
        return String(format: "%.0f%@", value, unit.accessibilityUnitName)
    }
}
