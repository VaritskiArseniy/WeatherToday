//
//  HourWeatherModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation


class HourWeatherModel {
    var temp: Int
    var main: String
    var description: String
    var dateTime: String
    
    init(weatherJson: NSDictionary) {
        if let main = weatherJson["main"] as? NSDictionary {
            temp = Int((main["temp"] as? Double ?? 0) - 273)
        } else {
            temp = 0
        }
        
        if let weatherArray = weatherJson["weather"] as? [NSDictionary],
           let weather = weatherArray.first {
            main = weather["main"] as? String ?? "Unknown"
            description = weather["description"] as? String ?? "Unknown"
        } else {
            main = "Unknown"
            description = "Unknown"
        }
        
        dateTime = weatherJson["dt_txt"] as? String ?? "Unknown"
    }
}

