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
    let locationName: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let humidity: Observable<String>
    let rain3h: Observable<String>
    let windSpeed: Observable<String>
    
    // MARK: - Services
    fileprivate var weatherService: ServiceProtocol
    
    // MARK: - init
    init(weather: Weather) {
        locationName = Observable(weather.location)
        iconText = Observable(weather.iconText)
        temperature = Observable(weather.temperature)
        rain3h = Observable(weather.rain3h)
        humidity = Observable(weather.humidity)
        windSpeed = Observable(weather.windSpeed)
        
        weatherService = OpenWeatherMapService()
    }
    
    // MARK: - private
    fileprivate func updateWeather(_ weather: Weather) {
        locationName.value = weather.location
        iconText.value = weather.iconText
        temperature.value = weather.temperature
        rain3h.value = weather.rain3h
        humidity.value = weather.humidity
        windSpeed.value = weather.windSpeed
    }
    
    fileprivate func updateWeather(_ error: Error) {
        locationName.value = emptyString
        iconText.value = emptyString
        temperature.value = emptyString
        humidity.value = emptyString
        windSpeed.value = emptyString
    }
    
    fileprivate func fetch5DayForecast() {

    }
}
