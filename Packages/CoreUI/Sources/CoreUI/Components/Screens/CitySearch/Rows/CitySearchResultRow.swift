import CoreModels
import SwiftUI

public struct CitySearchResultRow: View {
    let result: GeocodingResult
    let isAdded: Bool
    let onAdd: () -> Void

    public init(result: GeocodingResult, isAdded: Bool, onAdd: @escaping () -> Void) {
        self.result = result
        self.isAdded = isAdded
        self.onAdd = onAdd
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(result.name)
                    .font(Typography.rowTitleCompact)
                Text(result.country)
                    .font(Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if isAdded {
                Image(systemName: AppSymbol.cityAdded.rawValue)
                    .foregroundStyle(.green)
            } else {
                Button {
                    onAdd()
                } label: {
                    Image(systemName: AppSymbol.addCityButton.rawValue)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, Spacing.xxs)
    }
}
