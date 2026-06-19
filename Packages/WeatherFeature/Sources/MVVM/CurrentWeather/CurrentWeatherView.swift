import CoreModels
import CoreUI
import SwiftUI

// MARK: - CurrentWeatherView

public struct CurrentWeatherView: View {
    @State var viewModel: CurrentWeatherViewModel
    @Binding var weatherPath: NavigationPath
    let settings: AppSettings

    public init(
        viewModel: CurrentWeatherViewModel,
        weatherPath: Binding<NavigationPath>,
        settings: AppSettings
    ) {
        self.viewModel = viewModel
        self._weatherPath = weatherPath
        self.settings = settings
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear
                    .onAppear { viewModel.load() }

            case .loading:
                WeatherLoadingView()

            case let .loaded(weather):
                CurrentWeatherLoadedView(
                    weather: weather,
                    settings: settings,
                    onWeeklyForecast: {
                        weatherPath.append(WeatherDestination.weeklyForecast)
                    },
                    onHourlyChart: {
                        weatherPath.append(WeatherDestination.hourlyChart)
                    }
                )

            case let .error(error):
                WeatherErrorView(error: error) { viewModel.load() }
            }
        }
        .navigationTitle(
            viewModel.cityName.isEmpty ? L10n.currentWeatherLoading : viewModel.cityName
        )
        .refreshable {
            viewModel.refresh()
        }
    }
}
