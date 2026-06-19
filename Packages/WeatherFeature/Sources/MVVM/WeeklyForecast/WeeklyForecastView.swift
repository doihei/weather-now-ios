import CoreModels
import CoreUI
import SwiftUI

public struct WeeklyForecastView: View {
    let viewModel: WeeklyForecastViewModel
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(viewModel: WeeklyForecastViewModel, temperatureUnit: AppSettings.TemperatureUnit) {
        self.viewModel = viewModel
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        WeeklyForecastListView(forecasts: viewModel.dailyForecasts, temperatureUnit: temperatureUnit)
    }
}
