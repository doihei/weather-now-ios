---
paths:
  - Packages/CoreUI/**/*.swift
---

# CoreUI レイヤールール

## ディレクトリ構成

`Packages/CoreUI/Sources/CoreUI/`

| ディレクトリ | 対象ファイル |
|---|---|
| `Components/Atoms/` | WeatherIconView.swift, TemperatureText.swift, HourlyItemView.swift |
| `Components/Sections/` | CurrentWeatherSummaryView.swift, CurrentWeatherLoadedView.swift, HourlyForecastStripView.swift, WeatherDetailNavigationButtons.swift |
| `Components/States/` | WeatherLoadingView.swift, WeatherErrorView.swift |
| `Extensions/` | WeatherCode+SFSymbol.swift, Theme+ColorScheme.swift, Theme+DisplayName.swift, TemperatureUnit+AccessibilityName.swift, WindUnit+AccessibilityName.swift |
| `Localization/` | L10n.swift（自動生成）, LocalizedStringResource+Extension.swift |
| `Resources/` | Localizable.xcstrings |
| `Tokens/` | Spacing.swift, Size.swift（CornerRadius ネスト含む）, AppSymbol.swift |

## 設計原則・責務

### コンポーネント階層

- **Atoms**: 単独で意味を持つ最小単位
- **Sections**: Atoms を組み合わせた画面セクション単位
- **States**: ローディング・エラーなど画面状態を表すビュー

### SF Symbols 利用方針

SFSafeSymbols は CoreUI のみに依存させる。WeatherFeature 側では `AppSymbol.xxx.rawValue` を `systemImage:` に渡す。

```swift
// CoreUI/Extensions/WeatherCode+SFSymbol.swift — WMO コード → SFSymbol マッピング
extension WeatherCode {
    var symbol: SFSymbol { ... }
}
// CoreUI/Tokens/AppSymbol.swift — タブ・アクションボタン用シンボル定数
public enum AppSymbol {
    public static let weatherTab: SFSymbol = .cloudSunFill
}
```

### ローカライズ

- 文字列定義は `Resources/Localizable.xcstrings` に集約する
- `L10n.swift` は `make generate` で自動生成する — 手動編集不可
- locale 依存の表示文言（`displayName` / `accessibilityUnitName` など）は CoreUI の extension に置く（CoreModels には置かない）

### Design Tokens

マジックナンバーを使わず、必ず Tokens を参照する。

```swift
// OK
VStack(spacing: Spacing.large) { ... }
.frame(width: Size.iconMD)

// NG
VStack(spacing: 12) { ... }
.frame(width: 40)
```

## テスト設計

テストターゲット: `CoreUITests`（`Packages/CoreUI/Tests/CoreUITests/`）

CoreUI はビジュアル的な要素が多く、現状はスモークテスト 1 ファイルのみ（`CoreUITests.swift`）。
Tokens の定数値検証・L10n キーの存在確認など、UI 非依存の要素を優先して検証する。