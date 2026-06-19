//
//  CurrentWeatherLoadedView.swift
//  CoreUI
//
//  Created by Daihei Doi on 2026/06/19.
//

import CoreModels
import SwiftUI

public struct CurrentWeatherLoadedView: View {
    let weather: Weather
    let settings: AppSettings
    let onWeeklyForecast: () -> Void
    let onHourlyChart: () -> Void

    public init(
        weather: Weather,
        settings: AppSettings,
        onWeeklyForecast: @escaping () -> Void,
        onHourlyChart: @escaping () -> Void
    ) {
        self.weather = weather
        self.settings = settings
        self.onWeeklyForecast = onWeeklyForecast
        self.onHourlyChart = onHourlyChart
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxLarge) {
                CurrentWeatherSummaryView(current: weather.current, settings: settings)
                HourlyForecastStripView(
                    hourly: weather.hourly,
                    temperatureUnit: settings.temperatureUnit
                )
                WeatherDetailNavigationButtons(
                    onWeeklyForecast: onWeeklyForecast,
                    onHourlyChart: onHourlyChart
                )
            }
            .padding()
        }
    }
}
