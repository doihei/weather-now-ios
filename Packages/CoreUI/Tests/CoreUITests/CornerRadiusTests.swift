import Foundation
import Testing
@testable import CoreUI

struct CornerRadiusTests {
    @Test("CornerRadius の各トークンが意図した CGFloat 値である")
    func tokensHaveExpectedValues() {
        #expect(CornerRadius.xs == 4)
        #expect(CornerRadius.sm == 8)
        #expect(CornerRadius.md == 12)
        #expect(CornerRadius.lg == 16)
    }

    @Test("CornerRadius トークンは xs から lg にかけて単調増加する")
    func tokensAreStrictlyIncreasing() {
        let ordered: [CGFloat] = [
            CornerRadius.xs, CornerRadius.sm, CornerRadius.md, CornerRadius.lg,
        ]
        for (lhs, rhs) in zip(ordered, ordered.dropFirst()) {
            #expect(lhs < rhs)
        }
    }
}
