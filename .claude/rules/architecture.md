# アーキテクチャルール

## モジュール依存グラフ

```
WeatherFeatureMVVM ─┐
WeatherFeatureTCA  ─┤→ WeatherDomain → CoreNetwork → CoreModels
                    └→ CoreUI                       ↗
```

依存は**下向きのみ**。逆方向の依存は禁止。

## 各モジュールの責務

| モジュール | 置くもの | 置かないもの |
|---|---|---|
| CoreModels | データモデル、エラー型、設定値 | UI依存のコード、ネットワーク処理 |
| CoreNetwork | APIクライアント、レスポンス変換 | UI処理、ビジネスロジック |
| CoreUI | 共通UIコンポーネント、Design Tokens、ローカライズ（L10n） | ネットワーク処理、ビジネスロジック |
| WeatherDomain | Repository、LocationService | UI処理 |
| WeatherFeature | View、ViewModel / Feature | ネットワーク直接呼び出し |

## UI 関心事の判断基準

**CoreUI に置く（UIフレームワーク依存 or locale 依存）**
- SF Symbols マッピング（`SFSymbol` 型を返すもの）
- SwiftUI コンポーネント
- locale 依存の表示文言（`displayName` / `accessibilityUnitName` など）

**CoreModels に残す（locale 非依存）**
- 単位記号（`"℃"` / `"km/h"` など）
- 単位変換ロジック
- データモデル・エラー型・永続化キー

## 外部ライブラリの依存先

| ライブラリ | 依存させるモジュール |
|---|---|
| SFSafeSymbols | CoreUI のみ |
| swift-composable-architecture | WeatherFeatureTCA のみ |
| swift-dependencies | CoreNetwork・WeatherDomain・WeatherFeatureMVVM（各テストターゲット含む） |
| swift-dependencies（TCA 経由） | WeatherFeatureTCA・WeatherFeatureTCATests |

## ファイル構成

### CoreModels

```
CoreModels/
├── City/        — City（登録都市）, GeocodingResult（検索結果）
├── Errors/      — WeatherError
├── Settings/    — AppSettings（TemperatureUnit / WindUnit / Theme をネスト）
└── Weather/     — Weather, CurrentWeather, DailyForecast, HourlyForecast, WeatherCode
```

### CoreNetwork

```
CoreNetwork/
├── Clients/              — APIClient（ベース HTTP）, LiveXxxClient, TestXxxClient
├── Endpoints/            — OpenMeteoEndpoint（URL・クエリパラメータ定義）
├── Protocols/            — WeatherAPIClientProtocol, GeocodingAPIClientProtocol
├── Protocols/Dependencies/ — XxxClient+Dependency.swift（DependencyKey 定義）
└── Responses/            — ForecastResponse, GeocodingResponse（Decodable）
```

### WeatherDomain

```
WeatherDomain/
├── CityList/     — CityListService, CityListServiceProtocol, CityListService+Dependency
├── Location/     — LocationService（Actor）, LocationServiceProtocol, LocationService+Dependency
├── Repository/   — WeatherRepository（Actor・キャッシュ付き）, WeatherRepositoryProtocol, WeatherRepository+Dependency
└── Settings/     — AppSettingsService, AppSettingsServiceProtocol, AppSettingsService+Dependency
```

Protocol・実装・DependencyKey を同一ディレクトリに配置する（CoreNetwork の `Protocols/` 分離とは異なる）。

### CoreUI

```
CoreUI/
├── Components/
│   ├── Atoms/    — WeatherIconView, TemperatureText, HourlyItemView
│   ├── Rows/     — DailyForecastRow, CityWeatherRow, CitySearchResultRow
│   ├── Sections/ — CurrentWeatherSummaryView, HourlyForecastStripView, WeatherDetailNavigationButtons
│   ├── Screens/  — CurrentWeatherLoadedView, HourlyChartContentView, WeeklyForecastListView, SettingsFormView
│   └── States/   — WeatherLoadingView, WeatherErrorView
├── Extensions/
│   ├── Models/   — WeatherCode+SFSymbol, Theme+ColorScheme, Theme+DisplayName,
│   │               TemperatureUnit+AccessibilityName, WindUnit+AccessibilityName
│   └── Views/    — View+ErrorToast
├── Localization/ — L10n.swift（自動生成）, LocalizedStringResource+Extension
├── Resources/    — Localizable.xcstrings
└── Tokens/       — Spacing, Size, CornerRadius, AppSymbol
```

## MVVM vs TCA 実装方針

| 関心事 | MVVM（@Observable） | TCA（@Reducer） |
|---|---|---|
| 状態管理 | `@Observable` ViewModel | `State` struct |
| 非同期処理 | `Task` + TaskKey | `.run { }` + `.cancellable(id:)` |
| ナビゲーション | `AppViewModel` が `NavigationPath` を保持 | `RootFeature` が `StackState` を管理 |
| DI | `@Dependency` で注入（`testValue` 必須） | `@Dependency` で注入（`testValue` 必須） |
| debounce | `Task.sleep` + `checkCancellation()` | `clock.sleep(.milliseconds(300))` + `.cancellable(id:, cancelInFlight: true)` |
| 都市リスト | `[City]` を直接管理 | `IdentifiedArrayOf` + `.forEach` |

## エラーハンドリング

全エラーは `WeatherError` に集約する。

| case | 説明 |
|---|---|
| `locationDenied` | 位置情報権限が拒否されている |
| `locationUnavailable` | 位置情報の取得失敗 |
| `networkFailure(String)` | URLError などネットワーク系エラー |
| `decodingFailure` | JSON デコード失敗 |
| `cityLimitReached` | 登録都市数が上限（10 件）超過 |

## ファイル命名規則

- 通常ファイル: `TypeName.swift`
- Extension ファイル: `Type+Feature.swift`（例: `WeatherCode+SFSymbol.swift`）
- Protocol ファイル: `TypeNameProtocol.swift`
- テスト共有スタブ: `Stubs.swift`（各テストターゲットに 1 ファイル）
- 1 型 1 ファイル（複数の型を 1 ファイルにまとめない）

## Swift Testing 共通基盤

Swift Testing を使用する（XCTest は使わない）。

```swift
import Testing
@testable import ModuleName
```

### テスト構成

- 単一関心の型: `struct XxxTests { }`
- 複数の関心事: 外側を `enum`（インスタンス化不要）、関心事ごとに `struct` でネスト
- `@Suite` デコレータは付けない（Xcode の自動整形で除去されるため）

### テスト命名

- `@Test` 引数に **日本語で意図を記述する**
- メソッド名は英語のキャメルケース

### アサーション

| 場面 | 書き方 |
|---|---|
| 等値・条件チェック | `#expect(value == expected)` |
| nil でないことを確認してアンラップ | `try #require(optional)` |
| エラーが投げられることを確認 | `#expect(throws: SomeError.self) { try ... }` |
| テスト失敗を明示的に記録 | `Issue.record("reason")` |

エラーテストは `do/catch` + `Issue.record` パターンを使う。

### 非同期テスト

`async throws` をそのまま使う（XCTest の `expectation` は不要）。

## テスト実行コマンド

```bash
make test                # 全パッケージ
make test-models         # CoreModels のみ
make test-network        # CoreNetwork のみ
make test-domain         # WeatherDomain のみ
make test-feature-mvvm   # WeatherFeature MVVM のみ
make test-feature-tca    # WeatherFeature TCA のみ
make test-feature        # MVVM・TCA 両方
```

Xcode からは `WeatherNow.xcworkspace` を開き、各テストターゲットを選択して ⌘U で実行する。SPM パッケージのテストを WeatherNow アプリの TestPlan に含めることはできない。