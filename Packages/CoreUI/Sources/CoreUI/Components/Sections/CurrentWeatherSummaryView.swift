import CoreModels
import SwiftUI

// MARK: - CurrentWeatherSummaryView

/// 現在の天気サマリー（アイコン・天気名・気温・体感/湿度/風速）を表示する共通コンポーネント。
public struct CurrentWeatherSummaryView: View {
    let current: CurrentWeather
    let settings: AppSettings

    public init(current: CurrentWeather, settings: AppSettings) {
        self.current = current
        self.settings = settings
    }

    public var body: some View {
        VStack(alignment: .center, spacing: Spacing.large) {
            WeatherIconView(code: current.code, size: Size.iconLG)
            Text(current.code.description)
                .font(.title3)
                .foregroundStyle(.secondary)
            TemperatureText(celsius: current.temperature, unit: settings.temperatureUnit)
                .font(.system(size: Size.fontDisplay, weight: .thin))
            HStack(spacing: Spacing.xxLarge) {
                let feelsLike = settings.temperatureUnit.convert(current.feelsLike)
                let wind = settings.windUnit.convert(current.windSpeed)
                let feelsLikeStr = feelsLike.formatted(.number.precision(.fractionLength(0)))
                let windStr = wind.formatted(.number.precision(.fractionLength(1)))
                Label(
                    "\(L10n.currentWeatherFeelsLikePrefix) \(feelsLikeStr)\(settings.temperatureUnit.symbol)",
                    systemImage: AppSymbol.thermometer.rawValue
                )
                Label("\(current.humidity)%", systemImage: AppSymbol.humidity.rawValue)
                Label(
                    "\(windStr) \(settings.windUnit.symbol)",
                    systemImage: AppSymbol.wind.rawValue
                )
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel())
    }

    private func accessibilityLabel() -> String {
        let temp = settings.temperatureUnit.convert(current.temperature)
            .formatted(.number.precision(.fractionLength(0)))
        let feelsLike = settings.temperatureUnit.convert(current.feelsLike)
            .formatted(.number.precision(.fractionLength(0)))
        let wind = settings.windUnit.convert(current.windSpeed)
            .formatted(.number.precision(.fractionLength(1)))

        return [
            current.code.description,
            "\(temp)\(settings.temperatureUnit.accessibilityUnitName)",
            String(
                format: L10n.currentWeatherAccessibilityFeelsLikeFormat,
                feelsLike,
                settings.temperatureUnit.accessibilityUnitName
            ),
            String(format: L10n.currentWeatherAccessibilityHumidityFormat, current.humidity),
            String(
                format: L10n.currentWeatherAccessibilityWindFormat,
                wind,
                settings.windUnit.accessibilityUnitName
            ),
        ].joined(separator: "、")
    }
}
