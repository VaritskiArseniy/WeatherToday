//
//  DailyWeatherModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 25.07.24.
//

import Foundation 

struct DailyWeatherResponse: Decodable {
    let forecast: Forecast
}

struct Forecast: Decodable {
    let forecastday: [DailyWeatherModel]
}

class DailyWeatherModel: Decodable {
    var code: Int
    var maxTemp: Int
    var minTemp: Int
    var date: String
    
    enum CodingKeys: String, CodingKey {
       case date, day
    }
    
    enum DayKeys: String, CodingKey {
        case maxtemp_c, mintemp_c, condition
    }
    
    enum ConditionKeys: String, CodingKey{
        case code
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        date = try container.decode(String.self, forKey: .date)
        
        let dayContainer = try container.nestedContainer(keyedBy: DayKeys.self, forKey: .day)
        maxTemp = Int(try dayContainer.decode(Double.self, forKey: .maxtemp_c))
        minTemp = Int(try dayContainer.decode(Double.self, forKey: .mintemp_c))
        
        let conditionContainer = try dayContainer.nestedContainer(keyedBy: ConditionKeys.self, forKey: .condition)
        code = try conditionContainer.decode(Int.self, forKey: .code)
    }
}
