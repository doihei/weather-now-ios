import CoreModels
import CoreUI
import SwiftUI

// MARK: - CityListView

public struct CityListView: View {
    @State var viewModel: CityListViewModel
    @Binding var cityPath: NavigationPath
    let settings: AppSettings
    let makeCitySearchViewModel: () -> CitySearchViewModel

    public init(
        viewModel: CityListViewModel,
        cityPath: Binding<NavigationPath>,
        settings: AppSettings,
        makeCitySearchViewModel: @escaping () -> CitySearchViewModel
    ) {
        self.viewModel = viewModel
        self._cityPath = cityPath
        self.settings = settings
        self.makeCitySearchViewModel = makeCitySearchViewModel
    }

    public var body: some View {
        List {
            ForEach(viewModel.cities) { city in
                CityWeatherRow(
                    city: city,
                    weather: viewModel.citiesWeather[city.id],
                    temperatureUnit: settings.temperatureUnit
                )
            }
            .onDelete { viewModel.remove(at: $0) }
            .onMove { viewModel.move(from: $0, to: $1) }
        }
        .navigationTitle(L10n.cityListTitle)
        .toolbar {
            #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cityPath.append(CityDestination.search)
                    } label: {
                        Image(systemName: AppSymbol.addCity.rawValue)
                    }
                }
            #endif
        }
        .refreshable {
            viewModel.loadAllWeather()
        }
        .errorToast(message: viewModel.errorMessage)
        .task {
            viewModel.loadCities()
            viewModel.loadAllWeather()
        }
        .navigationDestination(for: CityDestination.self) { _ in
            CitySearchView(viewModel: makeCitySearchViewModel())
        }
    }
}
