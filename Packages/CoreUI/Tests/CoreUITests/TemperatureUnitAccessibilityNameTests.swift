import CoreModels
import Testing
@testable import CoreUI

struct TemperatureUnitAccessibilityNameTests {
    @Test("TemperatureUnit の accessibilityUnitName は空文字を返さない")
    func accessibilityNamesAreNonEmpty() {
        #expect(AppSettings.TemperatureUnit.celsius.accessibilityUnitName.isEmpty == false)
        #expect(AppSettings.TemperatureUnit.fahrenheit.accessibilityUnitName.isEmpty == false)
    }

    @Test("TemperatureUnit の各 case で accessibilityUnitName が衝突しない")
    func accessibilityNamesAreDistinct() {
        #expect(
            AppSettings.TemperatureUnit.celsius.accessibilityUnitName
                != AppSettings.TemperatureUnit.fahrenheit.accessibilityUnitName
        )
    }
}
