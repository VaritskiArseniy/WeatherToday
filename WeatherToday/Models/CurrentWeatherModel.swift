//
//  WeatherModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 22.07.24.
//

import Foundation

class CurrentWeatherModel {
    var lon: Double
    var lat: Double
    var city: String
    var country: String
    var currentTemp: Int
    var maxTemp: Int
    var minTemp: Int
    var main: String
    var description: String
    
    init(weatherJson: NSDictionary) {
        if let coord = weatherJson["coord"] as? NSDictionary {
            lon = coord["lon"] as? Double ?? 0.0
            lat = coord["lat"] as? Double ?? 0.0
        } else {
            lon = 0.0
            lat = 0.0
        }

        if let sys = weatherJson["sys"] as? NSDictionary {
            country = sys["country"] as? String ?? "Unknown"
        } else {
            country = "Unknown"
        }
        city = weatherJson["name"] as? String ?? "Unknown"
        
        if let main = weatherJson["main"] as? NSDictionary {
            currentTemp = Int((main["temp"] as? Double ?? 0) - 273)
            maxTemp = Int((main["temp_max"] as? Double ?? 0) - 273)
            minTemp = Int((main["temp_min"] as? Double ?? 0) - 273)
        } else {
            currentTemp = 0
            maxTemp = 0
            minTemp = 0
        }
        
        if let weatherArray = weatherJson["weather"] as? [NSDictionary],
           let weather = weatherArray.first {
            main = weather["main"] as? String ?? "Unknown"
            description = weather["description"] as? String ?? "Unknown"
        } else {
            main = "Unknown"
            description = "Unknown"
        }
    }
}
