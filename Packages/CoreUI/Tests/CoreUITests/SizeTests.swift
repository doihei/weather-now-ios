import Foundation
import Testing
@testable import CoreUI

enum SizeTests {
    struct IconSizeTests {
        @Test("アイコンサイズトークンが意図した値である")
        func iconSizesHaveExpectedValues() {
            #expect(Size.iconXS == 20)
            #expect(Size.iconSM == 24)
            #expect(Size.iconMD == 40)
            #expect(Size.iconLG == 64)
        }

        @Test("アイコンサイズは XS から LG にかけて単調増加する")
        func iconSizesAreStrictlyIncreasing() {
            let ordered: [CGFloat] = [Size.iconXS, Size.iconSM, Size.iconMD, Size.iconLG]
            for (lhs, rhs) in zip(ordered, ordered.dropFirst()) {
                #expect(lhs < rhs)
            }
        }
    }

    struct ComponentDimensionTests {
        @Test("touchTarget は HIG 推奨の 44pt 以上を満たす")
        func touchTargetMeetsHIGRecommendation() {
            #expect(Size.touchTarget >= 44)
        }

        @Test("コンポーネント寸法トークンが意図した値である")
        func componentDimensionsHaveExpectedValues() {
            #expect(Size.touchTarget == 48)
            #expect(Size.labelColumn == 72)
        }
    }

    struct ChartSizeTests {
        @Test("chartDefault が意図した値である")
        func chartDefaultHasExpectedValue() {
            #expect(Size.chartDefault == 200)
        }
    }
}
