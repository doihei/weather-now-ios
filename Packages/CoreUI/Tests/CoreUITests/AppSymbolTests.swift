import SFSafeSymbols
import Testing
@testable import CoreUI

enum AppSymbolTests {
    struct TabBarSymbolTests {
        @Test("タブ用シンボルが意図した SFSymbol と一致する")
        func tabSymbolsMatchExpected() {
            #expect(AppSymbol.weatherTab == .cloudSunFill)
            #expect(AppSymbol.cityTab == .building2Fill)
            #expect(AppSymbol.settingsTab == .gearshapeFill)
        }

        @Test("3 つのタブシンボルは互いに異なる")
        func tabSymbolsAreDistinct() {
            let symbols: Set<SFSymbol> = [
                AppSymbol.weatherTab, AppSymbol.cityTab, AppSymbol.settingsTab,
            ]
            #expect(symbols.count == 3)
        }
    }

    struct WeatherDetailSymbolTests {
        @Test("天気詳細用シンボルが意図した SFSymbol と一致する")
        func detailSymbolsMatchExpected() {
            #expect(AppSymbol.thermometer == .thermometerMedium)
            #expect(AppSymbol.humidity == .humidity)
            #expect(AppSymbol.wind == .wind)
            #expect(AppSymbol.weeklyForecast == .calendar)
            #expect(AppSymbol.hourlyChart == .chartLineUptrendXyaxis)
            #expect(AppSymbol.errorWarning == .exclamationmarkTriangle)
        }
    }

    struct CitySymbolTests {
        @Test("都市追加・一覧用シンボルが意図した SFSymbol と一致する")
        func citySymbolsMatchExpected() {
            #expect(AppSymbol.addCity == .plus)
            #expect(AppSymbol.cityAdded == .checkmarkCircleFill)
            #expect(AppSymbol.addCityButton == .plusCircle)
        }

        @Test("都市追加系シンボル 3 種は互いに異なる")
        func citySymbolsAreDistinct() {
            let symbols: Set<SFSymbol> = [
                AppSymbol.addCity, AppSymbol.cityAdded, AppSymbol.addCityButton,
            ]
            #expect(symbols.count == 3)
        }
    }
}
