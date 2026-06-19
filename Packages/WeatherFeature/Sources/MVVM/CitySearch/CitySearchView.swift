import CoreModels
import CoreUI
import SwiftUI

// MARK: - CitySearchView

public struct CitySearchView: View {
    @State var viewModel: CitySearchViewModel

    public init(viewModel: CitySearchViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            if viewModel.isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if viewModel.results.isEmpty, !viewModel.query.isEmpty {
                Text(L10n.citySearchEmptyResult)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.results) { result in
                    CitySearchResultRow(
                        result: result,
                        isAdded: viewModel.isCityAdded(result)
                    ) {
                        viewModel.addCity(result)
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .searchable(text: Binding(
            get: { viewModel.query },
            set: { viewModel.updateQuery($0) }
        ), prompt: L10n.citySearchSearchPrompt)
        .navigationTitle(L10n.citySearchTitle)
    }
}
