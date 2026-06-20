import CoreModels
import SwiftUI

// MARK: - HourlyForecastStripView

/// 「今日の予報」見出しと 24 時間分の予報を 3 時間刻みで水平スクロールするコンポーネント。
struct HourlyForecastStripView: View {
    let hourly: [HourlyForecast]
    let temperatureUnit: AppSettings.TemperatureUnit

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(L10n.currentWeatherTodayForecast)
                .font(Typography.sectionTitle)
                .accessibilityAddTraits(.isHeader)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xl) {
                    ForEach(hourlyItems) { forecast in
                        HourlyItemView(forecast: forecast, temperatureUnit: temperatureUnit)
                    }
                }
                .padding(.horizontal, Spacing.xs)
            }
        }
    }

    private var hourlyItems: [HourlyForecast] {
        stride(from: 0, to: min(hourly.count, 24), by: 3).map { hourly[$0] }
    }
}
