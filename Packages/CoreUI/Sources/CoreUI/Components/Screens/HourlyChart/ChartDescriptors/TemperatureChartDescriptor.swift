//
//  TemperatureChartDescriptor.swift
//  CoreUI
//
//  Created by Daihei Doi on 2026/06/19.
//

import Charts
import CoreModels
import SwiftUI

struct TemperatureChartDescriptor: AXChartDescriptorRepresentable {
    let forecasts: [HourlyForecast]
    let unit: AppSettings.TemperatureUnit

    func makeChartDescriptor() -> AXChartDescriptor {
        AXChartDescriptor(
            title: L10n.hourlyChartPrecipitation,
            summary: summary,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }

    // MARK: - Private

    private var summary: String {
        let temps = forecasts.map { unit.convert($0.temperature) }
        guard let min = temps.min(), let max = temps.max() else { return "" }
        let minStr = min.formatted(.number.precision(.fractionLength(0)))
        let maxStr = max.formatted(.number.precision(.fractionLength(0)))
        return String(
            format: L10n.hourlyChartTemperatureSummaryFormat,
            L10n.hourlyChartTemperature,
            minStr,
            unit.accessibilityUnitName,
            maxStr,
            unit.accessibilityUnitName
        )
    }

    private var xAxis: AXCategoricalDataAxisDescriptor {
        AXCategoricalDataAxisDescriptor(
            title: L10n.hourlyChartTime,
            categoryOrder: forecasts.map { $0.time.formatted(.dateTime.hour()) }
        )
    }

    private var yAxis: AXNumericDataAxisDescriptor {
        let temps = forecasts.map { unit.convert($0.temperature) }
        let min = (temps.min() ?? 0) - 2
        let max = (temps.max() ?? 0) + 2
        return AXNumericDataAxisDescriptor(
            title: String(
                format: L10n.hourlyChartAxisTitleFormat,
                L10n.hourlyChartTemperature,
                unit.accessibilityUnitName
            ),
            range: min ... max,
            gridlinePositions: []
        ) { value in
            "\(value.formatted(.number.precision(.fractionLength(0))))\(unit.accessibilityUnitName)"
        }
    }

    private var series: AXDataSeriesDescriptor {
        let dataPoints = forecasts.map { forecast in
            AXDataPoint(
                x: forecast.time.formatted(.dateTime.hour()),
                y: unit.convert(forecast.temperature),
                label: String(
                    format: L10n.hourlyChartDataPointLabelFormat,
                    forecast.time.formatted(.dateTime.hour()),
                    unit.convert(forecast.temperature).formatted(.number.precision(.fractionLength(1))),
                    unit.accessibilityUnitName
                )
            )
        }
        return AXDataSeriesDescriptor(
            name: L10n.hourlyChartTemperature,
            isContinuous: true,
            dataPoints: dataPoints
        )
    }
}
