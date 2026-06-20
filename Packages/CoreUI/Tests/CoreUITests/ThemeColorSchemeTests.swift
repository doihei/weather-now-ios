import CoreModels
import SwiftUI
import Testing
@testable import CoreUI

struct ThemeColorSchemeTests {
    @Test("Theme.system は nil を返し OS 設定に追従する")
    func systemThemeReturnsNil() {
        #expect(AppSettings.Theme.system.colorScheme == nil)
    }

    @Test("Theme.light は SwiftUI の ColorScheme.light にマップされる")
    func lightThemeMapsToLight() {
        #expect(AppSettings.Theme.light.colorScheme == .light)
    }

    @Test("Theme.dark は SwiftUI の ColorScheme.dark にマップされる")
    func darkThemeMapsToDark() {
        #expect(AppSettings.Theme.dark.colorScheme == .dark)
    }
}
