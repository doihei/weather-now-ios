import Charts
import ComposableArchitecture
import CoreModels
import CoreUI
import SwiftUI

// MARK: - HourlyChartView (TCA)

public struct HourlyChartView: View {
    let store: StoreOf<HourlyChartFeature>
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(store: StoreOf<HourlyChartFeature>, temperatureUnit: AppSettings.TemperatureUnit) {
        self.store = store
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxl) {
                temperatureChart
                precipitationChart
            }
            .padding()
        }
        .navigationTitle(L10n.hourlyChartTitle)
        .onAppear { store.send(.onAppear) }
    }

    // MARK: - Private Views

    private var temperatureChart: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(L10n.hourlyChartTemperature)
                .font(.headline)
            Chart(store.hourlyForecasts) { forecast in
                LineMark(
                    x: .value(L10n.hourlyChartTime, forecast.time),
                    y: .value(L10n.hourlyChartTemperature, temperatureUnit.convert(forecast.temperature))
                )
                .foregroundStyle(.orange)
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 6)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.hour())
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxisLabel(temperatureUnit.symbol)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: visibleDomainSeconds)
            .frame(height: Size.chartDefault)
        }
    }

    private var precipitationChart: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(L10n.hourlyChartPrecipitation)
                .font(.headline)
            Chart(store.hourlyForecasts) { forecast in
                BarMark(
                    x: .value(L10n.hourlyChartTime, forecast.time),
                    y: .value(L10n.hourlyChartPrecipitation, forecast.precipitation)
                )
                .foregroundStyle(.blue)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 6)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.hour())
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYScale(domain: 0 ... precipitationMax)
            .chartYAxisLabel("mm")
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: visibleDomainSeconds)
            .frame(height: Size.chartDefault)
        }
    }

    private var precipitationMax: Double {
        max(store.hourlyForecasts.map(\.precipitation).max() ?? 0, 1)
    }

    /// 横スクロール時の可視範囲（24時間 = 86,400 秒）
    private var visibleDomainSeconds: TimeInterval {
        3600 * 24
    }
}
