//
//  HourWeatherModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation

struct HourlyWeatherResponse: Decodable {
    let list: [HourWeatherModel]
}

struct Weather: Decodable {
    let main: String
    let description: String
}

class HourWeatherModel: Decodable {
    var temp: Int
    var main: String
    var description: String
    var dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather, dt_txt
    }
    
    enum MainKeys: String, CodingKey {
        case temp
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temp = Int(try mainContainer.decode(Double.self, forKey: .temp) - 273)
        
        let weatherArray = try container.decode([Weather].self, forKey: .weather)
        guard let weather = weatherArray.first else {
            throw DecodingError.dataCorruptedError(forKey: .weather, in: container, debugDescription: "Weather array is empty.")
        }
        
        main = weather.main
        description = weather.description
        
        dateTime = try container.decode(String.self, forKey: .dt_txt)
    }
}

