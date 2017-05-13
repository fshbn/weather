//
//  Weather.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation

struct Weather {
    let location: String
    let iconText: String
    let temperature: String
    let humidity: String
    let windSpeed: String
    let windDegree: String
    let cloudCoverage: String
    
    init(location: String, iconText: String, temperature: String, humidity: String, windSpeed: String, windDegree: String, cloudCoverage: String ) {
        self.location = location
        self.iconText = iconText
        self.temperature  = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDegree = windDegree
        self.cloudCoverage = cloudCoverage
    }
}
