---
paths:
  - Packages/CoreNetwork/**/*.swift
---

# CoreNetwork レイヤールール

## ディレクトリ構成

`Packages/CoreNetwork/Sources/CoreNetwork/`

| ディレクトリ | 対象ファイル |
|---|---|
| `Clients/` | APIClient.swift, WeatherAPIClient.swift, GeocodingAPIClient.swift |
| `Endpoints/` | OpenMeteoEndpoint.swift |
| `Protocols/` | WeatherAPIClientProtocol.swift, GeocodingAPIClientProtocol.swift |
| `Protocols/Dependencies/` | WeatherAPIClient+Dependency.swift, GeocodingAPIClient+Dependency.swift |
| `Responses/` | ForecastResponse.swift, GeocodingResponse.swift |

CoreNetwork のみ Protocol と実装を別ディレクトリに分離する（WeatherDomain は同一ディレクトリに配置するため異なる）。

## 設計原則・責務

- HTTP 通信・レスポンス変換のみを担う（ビジネスロジック・UI処理は置かない）
- URL・クエリパラメータは `OpenMeteoEndpoint` enum に集約し、クライアント実装内に直書きしない

```swift
// OK
let url = try OpenMeteoEndpoint.forecast(latitude: lat, longitude: lon).url
// NG
var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
```

- レスポンス構造体で `CodingKeys` が 2 段ネストになる場合は外側の struct をトップレベルに引き上げる（SwiftLint nesting ルール）

## テスト設計

テストターゲット: `CoreNetworkTests`（`Packages/CoreNetwork/Tests/CoreNetworkTests/`）

### 検証対象

| ファイル | 検証内容 |
|---|---|
| `OpenMeteoEndpointTests.swift` | URL 生成・クエリパラメータが正しく組み立てられること |
| `ForecastResponseTests.swift` | JSON デコード・`toWeather()` 変換結果 |
| `GeocodingResponseTests.swift` | JSON デコード・`toResults()` 変換・`country` が null の場合 |

### フィクスチャ JSON

テストファイル内に `private static let` でインラインの JSON バイト列を定義する。

```swift
private static let validJSON = Data("""
{
    "current": { "temperature_2m": 20.5, ... },
    "hourly": { ... },
    "daily": { ... }
}
""".utf8)
```

### URL クエリパース

クエリパラメータは専用のヘルパーで辞書化して検証する。

```swift
private func queryDict(from url: URL) -> [String: String] {
    let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
    return Dictionary(uniqueKeysWithValues: items.compactMap { i in
        i.value.map { (i.name, $0) }
    })
}
```