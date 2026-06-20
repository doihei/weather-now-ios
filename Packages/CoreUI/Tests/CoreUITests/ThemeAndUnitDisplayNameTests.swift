import CoreModels
import Testing
@testable import CoreUI

// 役割の異なる case 同士が L10n キー取り違え等で同じ表示文字列にならないことを担保する。
// 個別の L10n キー値はソース上自明・かつ翻訳変更で揺れるため検証しない。

enum ThemeAndUnitDisplayNameTests {
    struct ThemeDisplayNameTests {
        @Test("Theme.displayName は 3 つの case で互いに異なる")
        func displayNamesAreDistinct() {
            let names: Set<String> = [
                AppSettings.Theme.system.displayName,
                AppSettings.Theme.light.displayName,
                AppSettings.Theme.dark.displayName,
            ]
            #expect(names.count == 3)
        }
    }

    struct TemperatureUnitAccessibilityNameTests {
        @Test("TemperatureUnit.accessibilityUnitName は 2 つの case で互いに異なる")
        func accessibilityNamesAreDistinct() {
            #expect(
                AppSettings.TemperatureUnit.celsius.accessibilityUnitName
                    != AppSettings.TemperatureUnit.fahrenheit.accessibilityUnitName
            )
        }
    }

    struct WindUnitAccessibilityNameTests {
        @Test("WindUnit.accessibilityUnitName は 2 つの case で互いに異なる")
        func accessibilityNamesAreDistinct() {
            #expect(
                AppSettings.WindUnit.kmh.accessibilityUnitName
                    != AppSettings.WindUnit.mph.accessibilityUnitName
            )
        }
    }
}
