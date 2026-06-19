---
paths:
  - Packages/WeatherDomain/**/*.swift
---

# WeatherDomain レイヤールール

## ディレクトリ構成

`Packages/WeatherDomain/Sources/WeatherDomain/`

| ディレクトリ | 置くもの |
|---|---|
| `CityList/` | 登録都市の永続化サービス（Protocol・実装・DependencyKey） |
| `Location/` | CoreLocation ラッパー・位置情報取得 Actor（Protocol・実装・DependencyKey） |
| `Repository/` | 天気データ取得・キャッシュ管理 Actor（Protocol・実装・DependencyKey） |
| `Settings/` | ユーザー設定の永続化サービス（Protocol・実装・DependencyKey） |

Protocol・実装・DependencyKey を**同一ディレクトリ**に配置する（CoreNetwork の `Protocols/` 分離とは異なる）。

## 設計原則・責務

- ビジネスロジック・データ取得キャッシュ・位置情報取得を担う（UI処理は置かない）
- サービス・Repository は `actor` で実装し、Swift 6 の Sendable 安全性を確保する
- `@Dependency` の `testValue` を必ず定義する
- `CLLocationManager` のラップには delegate ではなく `AsyncStream` を使い、循環参照を防ぐ

### Actor 設計（キャッシュ）

```swift
actor WeatherRepository: WeatherRepositoryProtocol {
    private var cache: [CacheKey: Weather] = [:]

    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        let key = CacheKey(latitude: latitude, longitude: longitude)
        if let cached = cache[key] { return cached }
        let weather = try await apiClient.fetchWeather(...)
        cache[key] = weather
        return weather
    }
}
```

## テスト設計

テストターゲット: `WeatherDomainTests`（`Packages/WeatherDomain/Tests/WeatherDomainTests/`）

### DI（`withDependencies` + `CallCounter`）

Actor 再入性の検証には `CallCounter` actor を使う。

```swift
actor CallCounter {
    var count = 0
    func increment() { count += 1 }
}

@Test("キャッシュヒット時は API が再呼び出しされない")
func cacheHit() async throws {
    let counter = CallCounter()
    try await withDependencies {
        $0.weatherAPIClient = TestWeatherAPIClient { _, _ in
            await counter.increment()
            return Weather.stub()
        }
    } operation: {
        let repo = WeatherRepository()
        _ = try await repo.fetchWeather(latitude: 35.68, longitude: 139.69)
        _ = try await repo.fetchWeather(latitude: 35.68, longitude: 139.69)
    }
    #expect(await counter.count == 1)
}
```

### 永続化の分離

`UserDefaults` は UUID 隔離でテスト間の副作用を分離する（モックは使わずリアル実装で検証）。

```swift
let defaults = try #require(UserDefaults(suiteName: "test_\(UUID().uuidString)"))
let service = CityListService(defaults: defaults)
service.save([city])
#expect(CityListService(defaults: defaults).load().count == 1)
```

### エラーパス

`do/catch` + `Issue.record` パターンでエラー種別を検証する。

```swift
do {
    _ = try await repository.fetchWeather(latitude: 0, longitude: 0)
    Issue.record("エラーが投げられるべき")
} catch let error as WeatherError {
    #expect(error == .decodingFailure)
} catch {
    Issue.record("WeatherError 以外がスロー: \(error)")
}
```

### フィクスチャ

スタブは各テストファイル内に `private extension` で定義する（`Stubs.swift` は WeatherFeature テストのみ）。