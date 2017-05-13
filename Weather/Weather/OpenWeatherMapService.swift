//
//  OpenWeatherMapService.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation
import CoreLocation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

fileprivate let baseURL = "http://api.openweathermap.org/data/2.5/weather"
fileprivate let apiKey = "c6e381d8c7ff98f0fee43775817cf6ad"

struct OpenWeatherMapService: ServiceProtocol {
    
    fileprivate func generateRequestURL(_ location: CLLocation) -> URL? {
        guard var components = URLComponents(string:baseURL) else {
            return nil
        }
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:apiKey),
                                 URLQueryItem(name:"units", value:"metric")]
        
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
    
    func parseWeatherJson (json: [String: Any]) throws -> Weather {
        // Extract name
        guard let location = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract and validate weather
        guard let weatherJSON = json["weather"] as? [Any] else {
            throw SerializationError.missing("weather")
        }
        
        guard let firstWeatherObject = weatherJSON.first as? [String: Any] else {
            throw SerializationError.missing("weather")
        }
        
        // Extract and validate temperature
        guard let icon = firstWeatherObject["icon"] as? String else {
            throw SerializationError.missing("icon")
        }
        
        let weatherIcon = WeatherIcon(condition: 800, iconString: icon)
        
        // Extract and validate temperature
        guard let mainJSON = json["main"] as? [String: Int],
            let temp = mainJSON["temp"]
            else {
                throw SerializationError.missing("temp")
        }
        
        // Initialize properties
        return Weather(location: location, iconText: weatherIcon.iconText, temperature: String(describing: temp))
    }
}
