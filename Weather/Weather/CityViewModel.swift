//
//  CityViewModel.swift
//  Weather
//
//  Created by Boran ASLAN on 13/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation
import CoreLocation

class CityViewModel {

    // MARK: - Properties
    let cityName: Observable<String>
    let icon: Observable<String>
    let temperature: Observable<String>
    let precipitationProbability: Observable<String>
    let humidity: Observable<String>
    let windSpeed: Observable<String>
    let forecasts: Observable<[Forecast]>
    
    var lat: Double = 0
    var lon: Double = 0
    
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
        forecasts = Observable([])
        
        lat = weather.lat
        lon = weather.lon
        
        weatherService = OpenWeatherMapService()
        self.get5DayForecast()
    }
    
    fileprivate func get5DayForecast() {
        let location = CLLocation(latitude: lat, longitude: lon)
        
        weatherService.get5DayWeatherForecast(location) { forecastList, error -> Void in
            if let unwrappedError = error {
                self.updateForecasts(unwrappedError)
                return
            }
            
            guard let unwrappedForecasts = forecastList else {
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.updateForecasts(unwrappedForecasts)
            })
        }
    }
    
    // MARK: - private
    fileprivate func updateForecasts(_ forecasts: [Forecast]) {
        self.forecasts.value = forecasts
    }
    
    fileprivate func updateForecasts(_ error: WeatherError) {
        self.forecasts.value = []
    }
}
