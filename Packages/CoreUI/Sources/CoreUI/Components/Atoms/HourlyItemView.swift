//
//  HourlyItemView.swift
//  CoreUI
//
//  Created by Daihei Doi on 2026/06/19.
//

import CoreModels
import SwiftUI

public struct HourlyItemView: View {
    let forecast: HourlyForecast
    let temperatureUnit: AppSettings.TemperatureUnit

    public init(forecast: HourlyForecast, temperatureUnit: AppSettings.TemperatureUnit) {
        self.forecast = forecast
        self.temperatureUnit = temperatureUnit
    }

    public var body: some View {
        VStack(spacing: Spacing.sm) {
            Text(forecast.time, format: .dateTime.hour())
                .font(.caption2)
                .foregroundStyle(.secondary)
            WeatherIconView(code: forecast.code, size: Size.iconXS)
            TemperatureText(celsius: forecast.temperature, unit: temperatureUnit)
                .font(.caption)
        }
        .frame(width: Size.touchTarget)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let hour = forecast.time.formatted(.dateTime.hour())
        let temp = temperatureUnit.convert(forecast.temperature)
            .formatted(.number.precision(.fractionLength(0)))
        return String(
            format: L10n.hourlyItemAccessibilityLabelFormat,
            hour,
            forecast.code.description,
            temp,
            temperatureUnit.accessibilityUnitName
        )
    }
}
