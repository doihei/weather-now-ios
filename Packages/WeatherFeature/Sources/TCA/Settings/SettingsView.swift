import ComposableArchitecture
import CoreModels
import CoreUI
import SwiftUI

public struct SettingsView: View {
    let store: StoreOf<RootFeature>
    @State private var localSettings: AppSettings = .default

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        SettingsFormView(settings: $localSettings)
            .onAppear {
                localSettings = store.settings
            }
            .onChange(of: localSettings) { _, newSettings in
                store.send(.settingsChanged(newSettings))
            }
            .task {
                store.send(.onAppear)
            }
    }
}
