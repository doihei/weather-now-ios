---
paths:
  - Packages/CoreUI/**/*.swift
---

# CoreUI レイヤールール

## ディレクトリ構成

`Packages/CoreUI/Sources/CoreUI/`

| ディレクトリ | 置くもの |
|---|---|
| `Components/Atoms/` | 単独で意味を持つ最小 UI 単位（icon・text・cell） |
| `Components/Screens/<ScreenName>/` | 対象スクリーンのコンテンツビュー（VM/Store を持たない） |
| `Components/Screens/<ScreenName>/Sections/` | Atoms を組み合わせた画面内埋め込みブロック |
| `Components/Screens/<ScreenName>/States/` | ローディング・エラーなど全画面を占める状態ビュー |
| `Components/Screens/<ScreenName>/Rows/` | そのスクリーンの List 行コンポーネント |
| `Components/Screens/<ScreenName>/ChartDescriptors/` | `AXChartDescriptorRepresentable` 実装（グラフ画面のみ） |
| `Extensions/Models/` | CoreModels 型への UI 拡張（SFSymbol マッピング・locale 依存表示など） |
| `Extensions/Views/` | View 共通 modifier |
| `Localization/` | L10n.swift（自動生成）, LocalizedStringResource+Extension |
| `Resources/` | Localizable.xcstrings |
| `Tokens/` | Design Token 定数（Spacing / Size / CornerRadius / AppSymbol） |

## 設計原則・責務

### コンポーネント階層

- **Atoms**: 単独で意味を持つ最小単位（icon・text・cell）
- **Screens**: WeatherFeature の画面 body を担う 1 画面分コンテンツ（VM/Store を持たない）。スクリーンごとのサブディレクトリに以下を配置する:
  - **Sections**: Atoms を組み合わせた画面内埋め込みブロック
  - **States**: ローディング・エラーなど全画面を占める状態ビュー
  - **Rows**: List の 1 行として使うコンポーネント
  - **ChartDescriptors**: `AXChartDescriptorRepresentable` 実装（グラフ画面のみ）

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
VStack(spacing: Spacing.lg) { ... }
.frame(width: Size.iconMD)

// NG
VStack(spacing: 12) { ... }
.frame(width: 40)
```

## テスト設計

テストターゲット: `CoreUITests`（`Packages/CoreUI/Tests/CoreUITests/`）

CoreUI はビジュアル的な要素が多く、現状はスモークテスト 1 ファイルのみ（`CoreUITests.swift`）。
Tokens の定数値検証・L10n キーの存在確認など、UI 非依存の要素を優先して検証する。