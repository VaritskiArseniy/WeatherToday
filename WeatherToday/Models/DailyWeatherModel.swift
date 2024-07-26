//
//  DailyWeatherModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 25.07.24.
//

import Foundation 

class DailyWeatherModel {
    var code: Int
    var maxTemp: Int
    var minTemp: Int
    var date: String
    
    init(weatherJson: NSDictionary) {
        
        if let day = weatherJson["day"] as? NSDictionary {
            maxTemp = Int(day["maxtemp_c"] as? Double ?? 0)
            minTemp = Int(day["mintemp_c"] as? Double ?? 0)
            if let condition = day["condition"] as? NSDictionary {
                code = condition["code"] as? Int ?? 0
            } else {
                code = 0
            }
        } else {
            maxTemp = 0
            minTemp = 0
            code = 0
        }
        
        date = weatherJson["date"] as? String ?? ""
    }
}
