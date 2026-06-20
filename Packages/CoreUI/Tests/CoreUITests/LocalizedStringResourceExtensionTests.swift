import Foundation
import Testing
@testable import CoreUI

struct LocalizedStringResourceExtensionTests {
    @Test("string() は options なしで String(localized:) と同じ結果を返す")
    func stringWithoutOptionsMatchesStringLocalized() {
        let resource: LocalizedStringResource = "テスト文字列_未翻訳キー"
        #expect(resource.string() == String(localized: resource))
    }

    @Test("string(options:) は指定オプション付きの String(localized:options:) と同じ結果を返す")
    func stringWithOptionsMatchesStringLocalizedWithOptions() {
        let resource: LocalizedStringResource = "テスト文字列_オプション付き"
        let options = String.LocalizationOptions()
        #expect(resource.string(options: options) == String(localized: resource, options: options))
    }
}
