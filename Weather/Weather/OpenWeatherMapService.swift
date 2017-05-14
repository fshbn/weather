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
    
    fileprivate func generateRequestURL(_ location: CLLocation) -> URL? {
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
    
    func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping CompletionHandler) {
        guard let url = generateRequestURL(location) else {
            completionHandler(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(nil, error)
                }
                return
            }
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let weather = try self.parseWeatherJson(json: json!)
                completionHandler(weather, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
    
    fileprivate func parseWeatherJson (json: [String: Any]) throws -> Weather {
        var weather = Weather()
        // Extract and validate weather values
        if let cityId = json["id"] as? Int16 {
            weather.cityId = cityId
        } else {
            throw SerializationError.missing("id")
        }
        
        if let location = json["name"] as? String {
            weather.location = location
        } else {
            throw SerializationError.missing("name")
        }

        if let weatherJSON = json["weather"] as? [Any] {
            guard let firstWeatherObject = weatherJSON.first as? [String: Any] else {
                throw SerializationError.missing("weather")
            }
            
            if let icon = firstWeatherObject["icon"] as? String, let iconId = firstWeatherObject["id"] as? Int {
                weather.iconText = WeatherIcon(condition: iconId, iconString: icon).iconText
            } else {
                throw SerializationError.missing("icon")
            }
        } else {
            throw SerializationError.missing("weather")
        }
        
        if let mainJSON = json["main"] as? [String: Int] {
            if let temperature = mainJSON["temp"] {
                weather.temperature = String(describing: temperature)
            } else {
                throw SerializationError.missing("temp")
            }
            
            if let humidity = mainJSON["humidity"] {
                weather.humidity = String(describing: humidity)
            }
        }
        
        if let rainJSON = json["rain"] as? [String: Any] {
            if let rain3h = rainJSON["3h"] as? Int {
                weather.rain3h = String(describing: rain3h)
            }
        }
        
        if let windJSON = json["wind"] as? [String: Int] {
            if let windSpeed = windJSON["speed"] {
                weather.windSpeed = String(describing: windSpeed)
            }
        }
        
        // Initialize properties
        return weather
    }
    
}
