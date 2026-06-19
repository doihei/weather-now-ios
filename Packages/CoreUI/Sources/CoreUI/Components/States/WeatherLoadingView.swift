import SwiftUI

// MARK: - WeatherLoadingView

/// 天気取得中のローディング表示。ProgressView と読み込み中ラベルを縦に並べる。
public struct WeatherLoadingView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: Spacing.xLarge) {
            ProgressView()
            Text(L10n.currentWeatherLoading)
                .foregroundStyle(.secondary)
        }
    }
}
