//
//  HourWeatherService.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation

class HourWeatherService {
    let apiKey = "3443f5398bac843ff606f5305ad2fc9f"
    
    func fetchWeather(lat: String, lon: String, completion: @escaping ([HourWeatherModel]?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let list = json["list"] as? [NSDictionary] {
                        let weatherModels = list.map { HourWeatherModel(weatherJson: $0) }
                        completion(weatherModels)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } catch let error {
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
