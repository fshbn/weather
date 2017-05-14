//
//  CityViewModel.swift
//  Weather
//
//  Created by Boran ASLAN on 13/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation

class CityViewModel {

    // MARK: - Properties
    let cityName: Observable<String>
    let icon: Observable<String>
    let temperature: Observable<String>
    let precipitationProbability: Observable<String>
    let humidity: Observable<String>
    let windSpeed: Observable<String>
    
    // MARK: - Services
    fileprivate var weatherService: ServiceProtocol
    
    // MARK: - init
    init(weather: Weather) {
        cityName = Observable(weather.cityName)
        icon = Observable(weather.icon)
        temperature = Observable(String(format: "%.0f", weather.temperature) + "°")
        precipitationProbability = Observable(String(format: "%.0f", weather.precipitationProbability))
        humidity = Observable(String(format: "%.0f", weather.humidity))
        windSpeed = Observable(String(format: "%.0f", weather.windSpeed))
        
        weatherService = OpenWeatherMapService()
    }
    
    fileprivate func fetch5DayForecast() {

    }
}
