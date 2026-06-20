import CoreModels
import SwiftUI

public struct DailyForecastRow: View {
    let forecast: DailyForecast
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(forecast: DailyForecast, temperatureUnit: AppSettings.TemperatureUnit) {
        self.forecast = forecast
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        HStack(spacing: Spacing.lg) {
            Text(forecast.date, format: .dateTime.month().day().weekday(.abbreviated))
                .frame(width: Size.labelColumn, alignment: .leading)
                .font(Typography.subtitle)

            WeatherIconView(code: forecast.code, size: Size.iconSM)

            Text(forecast.code.description)
                .font(Typography.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer()

            TemperatureText(celsius: forecast.maxTemp, unit: temperatureUnit)
                .foregroundStyle(.red)
            Text("/")
                .foregroundStyle(.secondary)
            TemperatureText(celsius: forecast.minTemp, unit: temperatureUnit)
                .foregroundStyle(.blue)

            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                Text("\(forecast.precipitationProb)%")
                    .font(Typography.captionSmall)
                    .foregroundStyle(.blue)
                ProgressView(value: Double(forecast.precipitationProb), total: 100)
                    .frame(width: 40)
                    .tint(.blue)
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}
