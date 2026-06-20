import SFSafeSymbols
import Testing
@testable import CoreUI

enum AppSymbolTests {
    // 役割が同じグループ内のシンボルが意図せず同じ値（コピペミス）になっていないことを担保する。
    // 個別の SFSymbol 値（例: weatherTab == .cloudSunFill）はソース上自明なため検証しない。

    struct TabBarSymbolTests {
        @Test("3 つのタブシンボルは互いに異なる")
        func tabSymbolsAreDistinct() {
            let symbols: Set<SFSymbol> = [
                AppSymbol.weatherTab, AppSymbol.cityTab, AppSymbol.settingsTab,
            ]
            #expect(symbols.count == 3)
        }
    }

    struct CitySymbolTests {
        @Test("都市追加・追加済み・追加ボタンの 3 シンボルは互いに異なる")
        func citySymbolsAreDistinct() {
            let symbols: Set<SFSymbol> = [
                AppSymbol.addCity, AppSymbol.cityAdded, AppSymbol.addCityButton,
            ]
            #expect(symbols.count == 3)
        }
    }
}
