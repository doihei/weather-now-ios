//
//  PrecipitationChartDescriptor.swift
//  CoreUI
//
//  Created by Daihei Doi on 2026/06/19.
//

import Charts
import CoreModels
import SwiftUI

struct PrecipitationChartDescriptor: AXChartDescriptorRepresentable {
    let forecasts: [HourlyForecast]

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
        let total = forecasts.map(\.precipitation).reduce(0, +)
        return String(
            format: L10n.hourlyChartPrecipitationSummaryFormat,
            L10n.hourlyChartPrecipitation,
            total.formatted(.number.precision(.fractionLength(1))),
            L10n.hourlyChartPrecipitationUnitName
        )
    }

    private var xAxis: AXCategoricalDataAxisDescriptor {
        AXCategoricalDataAxisDescriptor(
            title: L10n.hourlyChartTime,
            categoryOrder: forecasts.map { $0.time.formatted(.dateTime.hour()) }
        )
    }

    private var yAxis: AXNumericDataAxisDescriptor {
        let max = max(forecasts.map(\.precipitation).max() ?? 0, 1)
        return AXNumericDataAxisDescriptor(
            title: String(
                format: L10n.hourlyChartAxisTitleFormat,
                L10n.hourlyChartPrecipitation,
                "mm"
            ),
            range: 0 ... max,
            gridlinePositions: []
        ) { value in
            "\(value.formatted(.number.precision(.fractionLength(1))))\(L10n.hourlyChartPrecipitationUnitName)"
        }
    }

    private var series: AXDataSeriesDescriptor {
        let dataPoints = forecasts.map { forecast in
            AXDataPoint(
                x: forecast.time.formatted(.dateTime.hour()),
                y: forecast.precipitation,
                label: String(
                    format: L10n.hourlyChartDataPointLabelFormat,
                    forecast.time.formatted(.dateTime.hour()),
                    forecast.precipitation.formatted(.number.precision(.fractionLength(1))),
                    L10n.hourlyChartPrecipitationUnitName
                )
            )
        }
        return AXDataSeriesDescriptor(
            name: L10n.hourlyChartPrecipitation,
            isContinuous: false,
            dataPoints: dataPoints
        )
    }
}
