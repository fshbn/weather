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
        // Extract and validate weather values
        guard let cityId = json["id"] as? Int16 else {
            throw SerializationError.missing("id")
        }
        
        guard let location = json["name"] as? String else {
            throw SerializationError.missing("name")
        }

        guard let weatherJSON = json["weather"] as? [Any] else {
            throw SerializationError.missing("weather")
        }
        
        guard let firstWeatherObject = weatherJSON.first as? [String: Any] else {
            throw SerializationError.missing("weather")
        }
        
        guard let icon = firstWeatherObject["icon"] as? String else {
            throw SerializationError.missing("icon")
        }
        
        guard let iconId = firstWeatherObject["id"] as? Int else {
            throw SerializationError.missing("iconId")
        }
        
        let weatherIcon = WeatherIcon(condition: iconId, iconString: icon)
        
        guard let mainJSON = json["main"] as? [String: Int] else {
                throw SerializationError.missing("main")
        }
        
        guard let temp = mainJSON["temp"] else {
            throw SerializationError.missing("temp")
        }

        guard let humidity = mainJSON["humidity"] else {
            throw SerializationError.missing("humidity")
        }
        
        guard let windJSON = json["wind"] as? [String: Int] else {
            throw SerializationError.missing("wind")
        }
        
        guard let windSpeed = windJSON["speed"] else {
            throw SerializationError.missing("speed")
        }
        
        // Initialize properties
        return Weather(cityId: cityId, location: location, iconText: weatherIcon.iconText, temperature: String(describing: temp), humidity: String(describing:humidity), windSpeed: String(describing:windSpeed))
    }
    
}
