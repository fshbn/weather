//
//  Weather.swift
//  Weather
//
//  Created by Boran ASLAN on 12/05/2017.
//  Copyright © 2017 Boran ASLAN. All rights reserved.
//

import Foundation

struct Weather {
    var cityId: Int16
    var location: String
    var iconText: String
    var temperature: String
    var rain3h: String
    var humidity: String
    var windSpeed: String
    
    init() {
        self.cityId = 0
        self.location = ""
        self.iconText = ""
        self.temperature  = ""
        self.rain3h = ""
        self.humidity = ""
        self.windSpeed = ""
    }
}
