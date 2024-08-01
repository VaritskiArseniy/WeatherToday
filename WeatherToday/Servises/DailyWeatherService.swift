//
//  DailyWeatherService.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 25.07.24.
//

import Foundation
import Alamofire

class DailyWeatherService {
    
    let apiKey = "f3acd10444c74bccb7770147242607"
    
    func fetchWeather(lat: String, lon: String, completion: @escaping ([DailyWeatherModel]?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=3&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        AF.request(url).responseDecodable(of: DailyWeatherResponse.self) { response in
            switch response.result {
            case .success(let dailyWeatherResponse):
                completion(dailyWeatherResponse.forecast.forecastday)
            case .failure(let error):
                print("Error fetching weather: \(error)")
                completion(nil)
            }
        }
    }
}

