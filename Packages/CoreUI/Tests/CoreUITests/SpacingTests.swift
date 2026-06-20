import Foundation
import Testing
@testable import CoreUI

struct SpacingTests {
    @Test("Spacing の各トークンが意図した CGFloat 値である")
    func tokensHaveExpectedValues() {
        #expect(Spacing.xxs == 2)
        #expect(Spacing.xs == 4)
        #expect(Spacing.sm == 6)
        #expect(Spacing.md == 8)
        #expect(Spacing.lg == 12)
        #expect(Spacing.xl == 16)
        #expect(Spacing.xxl == 24)
    }

    @Test("Spacing トークンは xxs から xxl にかけて単調増加する")
    func tokensAreStrictlyIncreasing() {
        let ordered: [CGFloat] = [
            Spacing.xxs, Spacing.xs, Spacing.sm,
            Spacing.md, Spacing.lg, Spacing.xl, Spacing.xxl,
        ]
        for (lhs, rhs) in zip(ordered, ordered.dropFirst()) {
            #expect(lhs < rhs)
        }
    }
}
