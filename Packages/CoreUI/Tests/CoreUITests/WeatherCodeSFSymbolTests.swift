import CoreModels
import SFSafeSymbols
import Testing
@testable import CoreUI

enum WeatherCodeSFSymbolTests {
    struct ClearAndCloudSymbolTests {
        @Test("晴れ・くもり系 WeatherCode が想定の SFSymbol を返す")
        func clearAndCloudSymbolsMapCorrectly() {
            #expect(WeatherCode.clearSky.symbol == .sunMaxFill)
            #expect(WeatherCode.mainlyClear.symbol == .sunMax)
            #expect(WeatherCode.partlyCloudy.symbol == .cloudSunFill)
            #expect(WeatherCode.overcast.symbol == .cloudFill)
        }
    }

    struct FogSymbolTests {
        @Test("霧・霧氷は cloudFogFill にマップされる")
        func fogVariantsShareSymbol() {
            #expect(WeatherCode.fog.symbol == .cloudFogFill)
            #expect(WeatherCode.rimeFog.symbol == .cloudFogFill)
        }
    }

    struct DrizzleAndRainSymbolTests {
        @Test("霧雨系の全 case が cloudDrizzleFill にマップされる")
        func drizzleVariantsShareSymbol() {
            #expect(WeatherCode.lightDrizzle.symbol == .cloudDrizzleFill)
            #expect(WeatherCode.moderateDrizzle.symbol == .cloudDrizzleFill)
            #expect(WeatherCode.denseDrizzle.symbol == .cloudDrizzleFill)
        }

        @Test("雨系の全 case が cloudRainFill にマップされる")
        func rainVariantsShareSymbol() {
            #expect(WeatherCode.lightRain.symbol == .cloudRainFill)
            #expect(WeatherCode.moderateRain.symbol == .cloudRainFill)
            #expect(WeatherCode.heavyRain.symbol == .cloudRainFill)
        }

        @Test("にわか雨系は cloudHeavyrainFill にマップされる")
        func rainShowerVariantsShareSymbol() {
            #expect(WeatherCode.lightRainShower.symbol == .cloudHeavyrainFill)
            #expect(WeatherCode.moderateRainShower.symbol == .cloudHeavyrainFill)
            #expect(WeatherCode.violentRainShower.symbol == .cloudHeavyrainFill)
        }
    }

    struct SnowSymbolTests {
        @Test("雪・みぞれ系の全 case が cloudSnowFill にマップされる")
        func snowVariantsShareSymbol() {
            #expect(WeatherCode.lightSnow.symbol == .cloudSnowFill)
            #expect(WeatherCode.moderateSnow.symbol == .cloudSnowFill)
            #expect(WeatherCode.heavySnow.symbol == .cloudSnowFill)
            #expect(WeatherCode.snowGrains.symbol == .cloudSnowFill)
            #expect(WeatherCode.lightSnowShower.symbol == .cloudSnowFill)
            #expect(WeatherCode.heavySnowShower.symbol == .cloudSnowFill)
        }
    }

    struct ThunderstormSymbolTests {
        @Test("雷雨は cloudBoltFill、ひょうを伴う雷雨は cloudBoltRainFill にマップされる")
        func thunderstormSymbolsMapCorrectly() {
            #expect(WeatherCode.thunderstorm.symbol == .cloudBoltFill)
            #expect(WeatherCode.thunderstormWithHail.symbol == .cloudBoltRainFill)
            #expect(WeatherCode.thunderstormWithHeavyHail.symbol == .cloudBoltRainFill)
        }
    }

    struct UnknownSymbolTests {
        @Test("未知の WeatherCode は questionmarkCircle にマップされる")
        func unknownMapsToQuestionmark() {
            #expect(WeatherCode.unknown.symbol == .questionmarkCircle)
        }
    }
}
