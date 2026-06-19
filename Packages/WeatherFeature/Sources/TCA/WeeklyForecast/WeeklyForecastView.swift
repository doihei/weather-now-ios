import ComposableArchitecture
import CoreModels
import CoreUI
import SwiftUI

public struct WeeklyForecastView: View {
    let store: StoreOf<WeeklyForecastFeature>
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(store: StoreOf<WeeklyForecastFeature>, temperatureUnit: AppSettings.TemperatureUnit) {
        self.store = store
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        WeeklyForecastListView(forecasts: store.dailyForecasts, temperatureUnit: temperatureUnit)
            .onAppear { store.send(.onAppear) }
    }
}
