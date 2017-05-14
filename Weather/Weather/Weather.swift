//
//  Weather.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation

struct Weather {
    let cityId: Int16
    let location: String
    let iconText: String
    let temperature: String
    let humidity: String
    let windSpeed: String
    let cloudCoverage: String
    
    init(cityId: Int16, location: String, iconText: String, temperature: String, humidity: String, windSpeed: String, cloudCoverage: String ) {
        self.cityId = cityId
        self.location = location
        self.iconText = iconText
        self.temperature  = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cloudCoverage = cloudCoverage
    }
}
