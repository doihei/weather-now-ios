import Foundation
import Testing
@testable import CoreUI

struct SizeTests {
    @Test("touchTarget は iOS HIG 推奨の 44pt 以上を満たす")
    func touchTargetMeetsHIGRecommendation() {
        // 外部仕様（iOS Human Interface Guidelines）への準拠を保証する。
        // 個別のサイズ値（iconXS 等）はソース上自明なため検証しない。
        #expect(Size.touchTarget >= 44)
    }
}
