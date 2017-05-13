//
//  HomeViewModel.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation

import CoreLocation

class HomeViewModel {
    // MARK: - Constants
    fileprivate let emptyString = ""
    
    // MARK: - Properties
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    let location: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let forecasts: Observable<[HomeViewController]>
    
    // MARK: - Services
    fileprivate var locationService: LocationService
    fileprivate var weatherService: ServiceProtocol
    
    // MARK: - init
    init() {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        location = Observable(emptyString)
        iconText = Observable(emptyString)
        temperature = Observable(emptyString)
        forecasts = Observable([])
        
        // Can put Dependency Injection here
        locationService = LocationService()
        weatherService = OpenWeatherMapService()
    }
    
    // MARK: - public
    func startLocationService() {
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    // MARK: - private
    fileprivate func update(_ weather: Weather) {
        //        hasError.value = false
        //        errorMessage.value = nil
        //
        location.value = weather.location
        iconText.value = weather.iconText
        temperature.value = weather.temperature
    }
    
    fileprivate func update(_ error: Error) {
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
        location.value = emptyString
        iconText.value = emptyString
        temperature.value = emptyString
    }
}

// MARK: LocationServiceDelegate
extension HomeViewModel: LocationServiceDelegate {
    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        locationService.stopLocationUpdates()
        weatherService.retrieveWeatherInfo(location) { weather, error -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedError = error {
                    print(unwrappedError)
                    self.update(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                
                self.update(unwrappedWeather)
            })
        }
    }
}
