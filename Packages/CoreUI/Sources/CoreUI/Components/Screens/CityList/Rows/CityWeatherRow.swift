import CoreModels
import SwiftUI

public struct CityWeatherRow: View {
    let city: City
    let weather: Weather?
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(city: City, weather: Weather?, temperatureUnit: AppSettings.TemperatureUnit) {
        self.city = city
        self.weather = weather
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(city.name)
                    .font(Typography.rowTitle)
                Text(city.country)
                    .font(Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let weather {
                HStack(spacing: Spacing.md) {
                    WeatherIconView(code: weather.current.code, size: Size.iconSM)
                    TemperatureText(celsius: weather.current.temperature, unit: temperatureUnit)
                        .font(Typography.emphasis)
                }
            } else {
                ProgressView()
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}
