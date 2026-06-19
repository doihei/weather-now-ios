import CoreModels
import CoreUI
import SwiftUI

public struct HourlyChartView: View {
    let hourlyForecasts: [HourlyForecast]
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(hourlyForecasts: [HourlyForecast], temperatureUnit: AppSettings.TemperatureUnit) {
        self.hourlyForecasts = hourlyForecasts
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        HourlyChartContentView(hourlyForecasts: hourlyForecasts, temperatureUnit: temperatureUnit)
    }
}
