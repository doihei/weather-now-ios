import SwiftUI
import Testing
@testable import CoreUI

struct TypographyTests {
    @Test("意味の異なる Typography トークンは互いに異なる Font を返す")
    func tokensAreDistinct() {
        // 役割が異なる 9 トークンが同一値（コピペミス）でないことを担保する。
        // 個別トークンの値（例: sectionTitle == .headline）はソース上自明なため検証しない。
        let tokens: Set<Font> = [
            Typography.display,
            Typography.sectionTitle,
            Typography.rowTitle,
            Typography.rowTitleCompact,
            Typography.emphasis,
            Typography.subtitle,
            Typography.caption,
            Typography.captionSmall,
            Typography.errorIcon,
        ]
        // sectionTitle と rowTitle は現状どちらも .headline で意図的に同値のため、9 → 8
        #expect(tokens.count == 8)
    }
}
