import CoreModels
import CoreUI
import SwiftUI

public struct SettingsView: View {
    @Bindable var appViewModel: AppViewModel

    public init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }

    public var body: some View {
        SettingsFormView(settings: $appViewModel.settings)
            .onChange(of: appViewModel.settings) {
                appViewModel.saveSettings()
            }
            .task {
                appViewModel.loadSettings()
            }
    }
}
