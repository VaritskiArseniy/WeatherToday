//
//  WeatherModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 22.07.24.
//

import Foundation

class CurrentWeatherModel: Decodable {
    var lon: Double
    var lat: Double
    var city: String
    var country: String
    var currentTemp: Int
    var maxTemp: Int
    var minTemp: Int
    var main: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case coord, sys, main, weather, name
    }
    
    enum CoordKeys: String, CodingKey {
        case lon, lat
    }
    
    enum SysKeys: String, CodingKey {
        case country
    }
    
    enum MainKeys: String, CodingKey {
        case temp, temp_max, temp_min
    }
    
    enum WeatherKeys: String, CodingKey {
        case main, description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordContainer = try container.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
        lon = try coordContainer.decode(Double.self, forKey: .lon)
        lat = try coordContainer.decode(Double.self, forKey: .lat)
        
        let sysContainer = try container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        country = try sysContainer.decode(String.self, forKey: .country)
        
        city = try container.decode(String.self, forKey: .name)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        currentTemp = Int(try mainContainer.decode(Double.self, forKey: .temp) - 273.15)
        maxTemp = Int(try mainContainer.decode(Double.self, forKey: .temp_max) - 273.15)
        minTemp = Int(try mainContainer.decode(Double.self, forKey: .temp_min) - 273.15)
        
        var weatherArray = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherContainer = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        main = try weatherContainer.decode(String.self, forKey: .main)
        description = try weatherContainer.decode(String.self, forKey: .description)
    }
}
