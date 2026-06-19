import ComposableArchitecture
import CoreModels
import CoreUI
import SwiftUI

// MARK: - CurrentWeatherView (TCA)

public struct CurrentWeatherView: View {
    let store: StoreOf<CurrentWeatherFeature>
    let settings: AppSettings

    public init(store: StoreOf<CurrentWeatherFeature>, settings: AppSettings) {
        self.store = store
        self.settings = settings
    }

    public var body: some View {
        Group {
            switch store.viewState {
            case .idle:
                Color.clear

            case .loading:
                WeatherLoadingView()

            case let .loaded(weather):
                CurrentWeatherLoadedView(
                    weather: weather,
                    settings: settings,
                    onWeeklyForecast: {
                        store.send(.showWeeklyForecast(weather))
                    },
                    onHourlyChart: {
                        store.send(.showHourlyChart(weather))
                    }
                )

            case let .error(error):
                WeatherErrorView(error: error) { store.send(.onAppear) }
            }
        }
        .navigationTitle(store.cityName.isEmpty ? L10n.currentWeatherTitle : store.cityName)
        .refreshable {
            store.send(.refresh)
        }
        .task {
            store.send(.onAppear)
        }
    }
}
