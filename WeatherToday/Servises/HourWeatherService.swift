//
//  HourWeatherService.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation
import Alamofire

class HourWeatherService {
    let apiKey = "3443f5398bac843ff606f5305ad2fc9f"
    
    func fetchWeather(lat: String, lon: String, completion: @escaping ([HourWeatherModel]?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        AF.request(url).responseDecodable(of: HourlyWeatherResponse.self) { response in
            switch response.result {
            case .success(let hourlyWeatherResponse):
                completion(hourlyWeatherResponse.list)
            case .failure(let error):
                print("Error fetching weather: \(error)")
                completion(nil)
            }
        }
    }
}
