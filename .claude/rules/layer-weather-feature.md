---
paths:
  - Packages/WeatherFeature/**/*.swift
---

# WeatherFeature レイヤールール

## ディレクトリ構成

```
Packages/WeatherFeature/
├── Sources/
│   ├── MVVM/               # SPM target: WeatherFeatureMVVM
│   │   ├── App/            # Tab 管理 ViewModel と RootView（アプリエントリポイント）
│   │   └── <ScreenName>/   # 各スクリーンの ViewModel（`@Observable`）と View
│   └── TCA/                # SPM target: WeatherFeatureTCA
│       ├── Root/           # Tab 管理 Feature と RootView（アプリエントリポイント）
│       └── <ScreenName>/   # 各スクリーンの Feature（`@Reducer`）と View
└── Tests/
    ├── WeatherFeatureMVVMTests/  # Stubs.swift + 各 ViewModel テスト
    └── WeatherFeatureTCATests/   # Stubs.swift + 各 Feature テスト
```

SPM デフォルトパスと異なるため、`Package.swift` で `path:` を明示する。

```swift
.target(name: "WeatherFeatureMVVM", ..., path: "Sources/MVVM")
.target(name: "WeatherFeatureTCA",  ..., path: "Sources/TCA")
.testTarget(name: "WeatherFeatureMVVMTests", ..., path: "Tests/WeatherFeatureMVVMTests")
.testTarget(name: "WeatherFeatureTCATests",  ..., path: "Tests/WeatherFeatureTCATests")
```

## 設計原則・責務

View・ViewModel（MVVM）/ Feature（TCA）を担う。ネットワーク直接呼び出しは禁止（WeatherDomain を介すこと）。

### MVVM 設計

| 関心事 | 実装方針 |
|---|---|
| 状態管理 | `@Observable` ViewModel |
| 非同期処理 | `Task` + TaskKey（Dictionary 管理） |
| ナビゲーション | `AppViewModel` が Tab 別 `NavigationPath` を保持 |
| DI | `@Dependency` で注入（`testValue` 必須） |
| debounce | `Task.sleep` + `checkCancellation()` |

### TCA 設計

| 関心事 | 実装方針 |
|---|---|
| 状態管理 | `State` struct |
| 非同期処理 | `.run { }` + `.cancellable(id: CancelID)` |
| ナビゲーション | `RootFeature` が `@Reducer enum WeatherPath / CityPath` で `StackState` を管理 |
| DI | `@Dependency` で注入（`testValue` 必須） |
| debounce | `clock.sleep(.milliseconds(300))` + `.cancellable(id:, cancelInFlight: true)` |
| 都市リスト | `IdentifiedArrayOf` + `.forEach` |
| 子→親通知 | Delegate Actions パターン（`CitySearchDelegate`） |

`@Reducer enum` の `State` / `Action` は macro が `Sendable` / `Equatable` を自動付与しないため extension で明示する。

```swift
@Reducer public enum WeatherPath { case weeklyForecast(WeeklyForecastFeature) }
extension WeatherPath.State: Equatable, Sendable {}
extension WeatherPath.Action: Sendable, Equatable {}
```

## テスト設計

テスト共有スタブは各テストターゲットの `Stubs.swift` に `extension` として定義する（MVVM/TCA 両方）。

### MVVM テスト（`WeatherFeatureMVVMTests`）

ViewModel が `@MainActor` のため、テスト struct にも `@MainActor` を付与する。

```swift
@MainActor
struct CityListViewModelTests {
    private func makeSUT(
        repository: StubWeatherRepository = StubWeatherRepository(),
        cityListDefaults: UserDefaults = UserDefaults(suiteName: "test_\(UUID().uuidString)")!
    ) -> CityListViewModel {
        withDependencies {
            $0.weatherRepository = repository
            $0.cityListService = CityListService(defaults: cityListDefaults)
        } operation: {
            CityListViewModel()
        }
    }
}
```

- `makeSUT()` ファクトリで ViewModel を生成する
- ViewModel 内の `Task { }` は即時完了しても非同期で走るため `Task.sleep` で完了を待機する
- `UserDefaults` は UUID 隔離でテスト間の副作用を分離する

```swift
vm.loadAllWeather()
try await Task.sleep(for: .milliseconds(100))
#expect(vm.citiesWeather[1] != nil)
```

### TCA テスト（`WeatherFeatureTCATests`）

`TestStore` + `TestClock` を使う。

```swift
@Test("300ms 後に検索が実行される")
func queryChangedTriggersSearchAfterDebounce() async {
    let clock = TestClock()
    let store = TestStore(initialState: CitySearchFeature.State()) {
        CitySearchFeature()
    } withDependencies: {
        $0.continuousClock = clock
        $0.weatherRepository = StubWeatherRepository()
    }
    await store.send(.queryChanged("東京")) { $0.isSearching = true }
    await clock.advance(by: .milliseconds(300))
    await store.receive(.searchResponse(.success([]))) { $0.isSearching = false }
}
```

- `exhaustivity` を設定して意図しない Action 漏れを検出・制御する
- debounce は `TestClock.advance(by:)` で時間をコントロールする
- Delegate Actions は `store.receive(.delegate(...))` で検証する