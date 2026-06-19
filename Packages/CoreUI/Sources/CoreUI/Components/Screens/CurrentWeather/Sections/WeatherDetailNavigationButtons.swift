import SwiftUI

// MARK: - WeatherDetailNavigationButtons

/// 「週間予報」「24時間グラフ」へ遷移する 2 つのボタンを並べた共通コンポーネント。
/// 遷移処理は呼び出し側がクロージャで注入する。
struct WeatherDetailNavigationButtons: View {
    let onWeeklyForecast: () -> Void
    let onHourlyChart: () -> Void

    var body: some View {
        HStack(spacing: Spacing.xl) {
            Button(action: onWeeklyForecast) {
                Label(
                    L10n.currentWeatherWeeklyForecastButton,
                    systemImage: AppSymbol.weeklyForecast.rawValue
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.blue)

            Button(action: onHourlyChart) {
                Label(
                    L10n.currentWeatherHourlyChartButton,
                    systemImage: AppSymbol.hourlyChart.rawValue
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
    }
}
