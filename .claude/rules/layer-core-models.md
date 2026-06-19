---
paths:
  - Packages/CoreModels/**/*.swift
---

# CoreModels レイヤールール

## ディレクトリ構成

`Packages/CoreModels/Sources/CoreModels/`

| ディレクトリ | 置くもの |
|---|---|
| `City/` | 都市関連モデル（登録都市・検索結果） |
| `Errors/` | アプリ共通エラー型 |
| `Settings/` | ユーザー設定モデル（温度単位・風速単位・テーマをネスト定義） |
| `Weather/` | 天気データモデル（現在・時間帯・日次）・WMO コード変換 |

## 設計原則・責務

- UI に依存しない純粋なデータモデルのみを置く
- すべてのモデルは `struct + Sendable + Equatable` で定義する（`class` は使わない）
- エラー型は `WeatherError` enum に集約する
- locale 非依存の要素（単位記号 `"℃"` / `"km/h"` など）はここに置く
- SF Symbols マッピング・SwiftUI 依存・locale 依存の表示文言は CoreUI に置く

## テスト設計

テストターゲット: `CoreModelsTests`（`Packages/CoreModels/Tests/CoreModelsTests/`）

### 方針

- 外部依存なし（`withDependencies` / `@MainActor` は不要）
- ネットワーク・UserDefaults などの副作用なし
- 変換ロジック・境界値・未知コードのフォールバックを重点的に検証する

### パラメータ化テスト

`zip` で入力と期待値をまとめる。

```swift
@Test("WMOコードが WeatherCode に正しく変換される", arguments: zip(
    [0, 1, 61, 95],
    [WeatherCode.clearSky, .mainlyClear, .lightRain, .thunderstorm]
))
func wmoCodeConversion(wmoCode: Int, expected: WeatherCode) {
    #expect(WeatherCode(wmoCode: wmoCode) == expected)
}
```

### フィクスチャ

スタブは各テストファイル内に `private extension` で定義する（共有スタブファイルは不要）。