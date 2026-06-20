import CoreModels
import SwiftUI

// MARK: - WeatherErrorView

/// WeatherError をユーザー向けに表示する共通コンポーネント。
/// リトライ可能なエラーは「再試行」ボタン、それ以外（位置情報拒否など）は iOS で「設定を開く」を表示する。
public struct WeatherErrorView: View {
    let error: WeatherError
    let onRetry: () -> Void

    public init(error: WeatherError, onRetry: @escaping () -> Void) {
        self.error = error
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: AppSymbol.errorWarning.rawValue)
                .font(Typography.errorIcon)
                .foregroundStyle(.orange)
            Text(error.userMessage)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            if error.isRetryable {
                Button(L10n.currentWeatherRetry, action: onRetry)
                    .buttonStyle(.bordered)
            } else {
                #if os(iOS)
                    Button(L10n.currentWeatherOpenSettings) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .buttonStyle(.bordered)
                #endif
            }
        }
        .padding()
    }
}
