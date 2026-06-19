import ComposableArchitecture
import CoreModels
import CoreUI
import SwiftUI

public struct CityRowView: View {
    let store: StoreOf<CityRowFeature>
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(store: StoreOf<CityRowFeature>, temperatureUnit: AppSettings.TemperatureUnit) {
        self.store = store
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        CityWeatherRow(city: store.city, weather: store.weather, temperatureUnit: temperatureUnit)
            .onAppear { store.send(.onAppear) }
    }
}
