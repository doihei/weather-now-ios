import CoreModels
import Testing
@testable import CoreUI

struct WindUnitAccessibilityNameTests {
    @Test("WindUnit の accessibilityUnitName は空文字を返さない")
    func accessibilityNamesAreNonEmpty() {
        #expect(AppSettings.WindUnit.kmh.accessibilityUnitName.isEmpty == false)
        #expect(AppSettings.WindUnit.mph.accessibilityUnitName.isEmpty == false)
    }

    @Test("WindUnit の各 case で accessibilityUnitName が衝突しない")
    func accessibilityNamesAreDistinct() {
        #expect(
            AppSettings.WindUnit.kmh.accessibilityUnitName
                != AppSettings.WindUnit.mph.accessibilityUnitName
        )
    }
}
