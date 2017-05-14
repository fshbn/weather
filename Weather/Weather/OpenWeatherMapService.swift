//
//  OpenWeatherMapService.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate let baseURL = "http://api.openweathermap.org"
fileprivate let apiKey = "c6e381d8c7ff98f0fee43775817cf6ad"
fileprivate let unit = "metric"

struct OpenWeatherMapService: ServiceProtocol {
    
    fileprivate func generateRequestWeatherURL(_ location: CLLocation) -> URL? {
        guard var components = URLComponents(string:baseURL) else {
            return nil
        }
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        components.path = "/data/2.5/weather"
        
        components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:apiKey),
                                 URLQueryItem(name:"units", value:unit)]
    
        return components.url
    }
    
    func getWeatherInfo(_ location: CLLocation, completionHandler: @escaping CompletionHandler) {
        guard let url = generateRequestWeatherURL(location) else {
            completionHandler(nil, WeatherError.requestError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, WeatherError.networkError)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, WeatherError.dataError)
                return
            }
            
            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
                    if json["id"] != nil {
                        let weather = Weather(json: json)
                        completionHandler(weather, nil)
                    } else {
                        completionHandler(nil, WeatherError.dataError)
                    }
                } else {
                    completionHandler(nil, WeatherError.JSONParseError)
                }
            }
        }
        
        task.resume()
    }
    
    func get5DayWeatherForecast(_ location: CLLocation, completionHandler: @escaping CompletionHandler) {
        guard let url = generateRequestWeatherURL(location) else {
            completionHandler(nil, WeatherError.requestError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, WeatherError.networkError)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, WeatherError.dataError)
                return
            }
            
            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] {
                    if json["id"] != nil {
                        let weather = Weather(json: json)
                        completionHandler(weather, nil)
                    } else {
                        completionHandler(nil, WeatherError.dataError)
                    }
                } else {
                    completionHandler(nil, WeatherError.JSONParseError)
                }
            }
        }
        
        task.resume()
    }
    
}
