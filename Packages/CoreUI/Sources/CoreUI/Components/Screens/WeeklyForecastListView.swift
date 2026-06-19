import CoreModels
import SwiftUI

public struct WeeklyForecastListView: View {
    let forecasts: [DailyForecast]
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(forecasts: [DailyForecast], temperatureUnit: AppSettings.TemperatureUnit) {
        self.forecasts = forecasts
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        List(forecasts) { forecast in
            DailyForecastRow(forecast: forecast, temperatureUnit: temperatureUnit)
        }
        .navigationTitle(L10n.weeklyForecastTitle)
    }
}
