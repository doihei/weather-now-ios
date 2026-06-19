import Charts
import CoreModels
import SwiftUI

public struct HourlyChartContentView: View {
    let hourlyForecasts: [HourlyForecast]
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(hourlyForecasts: [HourlyForecast], temperatureUnit: AppSettings.TemperatureUnit) {
        self.hourlyForecasts = hourlyForecasts
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
    }

    private var temperatureChart: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(L10n.hourlyChartTemperature)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Chart(hourlyForecasts) { forecast in
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
            .accessibilityChartDescriptor(
                TemperatureChartDescriptor(
                    forecasts: hourlyForecasts,
                    unit: temperatureUnit
                )
            )
        }
    }

    private var precipitationChart: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(L10n.hourlyChartPrecipitation)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Chart(hourlyForecasts) { forecast in
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
            .accessibilityChartDescriptor(
                PrecipitationChartDescriptor(forecasts: hourlyForecasts)
            )
        }
    }

    private var precipitationMax: Double {
        max(hourlyForecasts.map(\.precipitation).max() ?? 0, 1)
    }

    private var visibleDomainSeconds: TimeInterval {
        3600 * 24
    }
}
