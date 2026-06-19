import ComposableArchitecture
import CoreModels
import CoreUI
import SwiftUI

public struct HourlyChartView: View {
    let store: StoreOf<HourlyChartFeature>
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(store: StoreOf<HourlyChartFeature>, temperatureUnit: AppSettings.TemperatureUnit) {
        self.store = store
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        HourlyChartContentView(hourlyForecasts: store.hourlyForecasts, temperatureUnit: temperatureUnit)
            .onAppear { store.send(.onAppear) }
    }
}
