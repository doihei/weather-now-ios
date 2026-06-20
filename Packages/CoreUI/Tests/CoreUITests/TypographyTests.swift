import SwiftUI
import Testing
@testable import CoreUI

struct TypographyTests {
    @Test("display は 64pt thin の system フォントである")
    func displayUsesSystemSixtyFourThin() {
        #expect(Typography.display == Font.system(size: 64, weight: .thin))
    }

    @Test("sectionTitle は headline と一致する")
    func sectionTitleEqualsHeadline() {
        #expect(Typography.sectionTitle == Font.headline)
    }

    @Test("rowTitle は headline と一致する")
    func rowTitleEqualsHeadline() {
        #expect(Typography.rowTitle == Font.headline)
    }

    @Test("rowTitleCompact は body と一致する")
    func rowTitleCompactEqualsBody() {
        #expect(Typography.rowTitleCompact == Font.body)
    }

    @Test("emphasis は title3 と一致する")
    func emphasisEqualsTitle3() {
        #expect(Typography.emphasis == Font.title3)
    }

    @Test("subtitle は subheadline と一致する")
    func subtitleEqualsSubheadline() {
        #expect(Typography.subtitle == Font.subheadline)
    }

    @Test("caption は caption と一致する")
    func captionEqualsCaption() {
        #expect(Typography.caption == Font.caption)
    }

    @Test("captionSmall は caption2 と一致する")
    func captionSmallEqualsCaption2() {
        #expect(Typography.captionSmall == Font.caption2)
    }

    @Test("errorIcon は largeTitle と一致する")
    func errorIconEqualsLargeTitle() {
        #expect(Typography.errorIcon == Font.largeTitle)
    }

    @Test("意味の異なるトークンが意図せず同じ値にならない")
    func distinctTokensRemainDistinct() {
        // 役割が異なるトークン同士はコピペミスによる衝突を起こさないこと
        #expect(Typography.display != Typography.emphasis)
        #expect(Typography.display != Typography.errorIcon)
        #expect(Typography.sectionTitle != Typography.rowTitleCompact)
        #expect(Typography.emphasis != Typography.subtitle)
        #expect(Typography.caption != Typography.captionSmall)
        #expect(Typography.rowTitleCompact != Typography.emphasis)
    }
}
