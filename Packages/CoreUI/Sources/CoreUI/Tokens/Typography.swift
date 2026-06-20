import SwiftUI

/// アプリ全体のフォントスタイルを表すデザイントークン。
/// UI 上の役割（semantic）ベースで命名し、将来のリブランド時に 1 ファイル変更で全画面へ波及させる。
public enum Typography {
    // TODO: AX5 でも比例拡大が必要になったら Font.custom(_, size:, relativeTo: .largeTitle) へ移行する。
    /// 巨大数値の表示用（現在気温など、画面の視覚的クライマックスとなる箇所）。
    /// 固定サイズのため Dynamic Type には追従しない。
    public static let display: Font = .system(size: 64, weight: .thin)

    /// セクション見出し（例：「今日の予報」「24時間気温」「降水量」）。
    public static let sectionTitle: Font = .headline

    /// リスト行の主見出し（例：CityList の都市名）。
    public static let rowTitle: Font = .headline

    /// 控えめなリスト行見出し（例：CitySearch 結果の都市名）。
    public static let rowTitleCompact: Font = .body

    /// 行内・サマリ内の強調（例：都市行の気温・天気状態名）。
    public static let emphasis: Font = .title3

    /// 副見出し（例：週間予報の日付列）。
    public static let subtitle: Font = .subheadline

    /// 補助情報（国名・体感/湿度/風速・トースト・検索エラー・天気説明など）。
    public static let caption: Font = .caption

    /// 最小補助情報（例：時刻スタンプ・降水確率）。
    public static let captionSmall: Font = .caption2

    /// エラー画面の SF Symbol アイコン用。
    public static let errorIcon: Font = .largeTitle
}
