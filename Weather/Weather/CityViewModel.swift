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
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    let locationName: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let humidity: Observable<String>
    let windSpeed: Observable<String>
    let cloudCoverage: Observable<String>
    
    // MARK: - Services
    fileprivate var weatherService: ServiceProtocol
    
    // MARK: - init
    init(weather: Weather) {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        locationName = Observable(weather.location)
        iconText = Observable(weather.iconText)
        temperature = Observable(weather.temperature)
        humidity = Observable(weather.humidity)
        windSpeed = Observable(weather.windSpeed)
        cloudCoverage = Observable(weather.cloudCoverage)

        weatherService = OpenWeatherMapService()
    }
    
    // MARK: - private
    fileprivate func updateWeather(_ weather: Weather) {
        //        hasError.value = false
        //        errorMessage.value = nil
        //
        locationName.value = weather.location
        iconText.value = weather.iconText
        temperature.value = weather.temperature
        humidity.value = weather.humidity
        windSpeed.value = weather.windSpeed
        cloudCoverage.value = weather.cloudCoverage
    }
    
    fileprivate func updateWeather(_ error: Error) {
        //        hasError.value = true
        //
        //        switch error.errorCode {
        //        case .urlError:
        //            errorMessage.value = "The weather service is not working."
        //        case .networkRequestFailed:
        //            errorMessage.value = "The network appears to be down."
        //        case .jsonSerializationFailed:
        //            errorMessage.value = "We're having trouble processing weather data."
        //        case .jsonParsingFailed:
        //            errorMessage.value = "We're having trouble parsing weather data."
        //        }
        //
        locationName.value = emptyString
        iconText.value = emptyString
        temperature.value = emptyString
        humidity.value = emptyString
        windSpeed.value = emptyString
        cloudCoverage.value = emptyString
    }
    
    fileprivate func fetch5DayForecast() {

    }
}
