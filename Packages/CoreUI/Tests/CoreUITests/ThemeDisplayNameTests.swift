import CoreModels
import Testing
@testable import CoreUI

struct ThemeDisplayNameTests {
    @Test("Theme の displayName は空文字を返さない")
    func displayNamesAreNonEmpty() {
        #expect(AppSettings.Theme.system.displayName.isEmpty == false)
        #expect(AppSettings.Theme.light.displayName.isEmpty == false)
        #expect(AppSettings.Theme.dark.displayName.isEmpty == false)
    }

    @Test("Theme の displayName は 3 つすべて互いに異なる")
    func displayNamesAreDistinct() {
        let names: Set<String> = [
            AppSettings.Theme.system.displayName,
            AppSettings.Theme.light.displayName,
            AppSettings.Theme.dark.displayName,
        ]
        #expect(names.count == 3)
    }
}
