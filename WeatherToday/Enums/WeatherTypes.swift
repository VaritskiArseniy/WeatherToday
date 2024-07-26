//
//  WeatherTypes.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 26.07.24.
//

import Foundation

enum WeatherTypes {
    case sun
    case clouds
    case rain
    case snow
    
    var codes: [Int] {
        switch self {
        case .sun:
            return [1000]
            
        case .clouds:
            return [1003, 1006, 1009, 1030, 1135, 1147]
            
        case .rain:
            return [1063, 1087, 1087, 1153, 1168, 1171, 1180, 1183, 1186, 1189, 
                    1192, 1195, 1198, 1201, 1240, 1243, 1246, 1273, 1276, 1069, 1204, 1207, 1249,
                    1252]
            
        case .snow:
            return [1066, 1114, 1117, 1210, 1213, 1216, 1219, 1222, 1225, 1237, 1255, 1258,
                    1279, 1282, 1261, 1264]
        }
    }
    
    static func weatherType(for code: Int) -> WeatherTypes {
        if WeatherTypes.sun.codes.contains(code) {
            return .sun
        } else if WeatherTypes.clouds.codes.contains(code) {
            return .clouds
        } else if WeatherTypes.rain.codes.contains(code) {
            return .rain
        } else if WeatherTypes.snow.codes.contains(code) {
            return .snow
        } else {
            return .clouds
        }
    }
}
