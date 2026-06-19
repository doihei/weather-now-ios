import CoreModels
import SFSafeSymbols
import SwiftUI

// MARK: - WeatherIconView

/// WeatherCode を SF Symbol で表示する共通コンポーネント。
public struct WeatherIconView: View {
    let code: WeatherCode
    let size: CGFloat
    let isDecorative: Bool

    public init(code: WeatherCode, size: CGFloat = Size.iconMD, isDecorative: Bool = true) {
        self.code = code
        self.size = size
        self.isDecorative = isDecorative
    }

    public var body: some View {
        Image(systemSymbol: code.symbol)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            // 装飾時は読み上げ対象から外す。情報を持たせたい画面では false にして↓のlabelを使う
            .accessibilityHidden(isDecorative)
            .accessibilityLabel(isDecorative ? "" : code.description)
    }
}
