//
//  DailyWeatherService.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 25.07.24.
//

import Foundation

class DailyWeatherService {
    
    let apiKey = "f3acd10444c74bccb7770147242607"
    
    func fetchWeather(lat: String, lon: String, completion: @escaping ([DailyWeatherModel]?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=3&aqi=no&alerts=no"
     
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
                    if let forecast = json["forecast"] as? NSDictionary {
                        if let list = forecast["forecastday"] as? [NSDictionary] {
                            let weatherModels = list.map { DailyWeatherModel(weatherJson: $0) }
                            completion(weatherModels)
                        } else {
                            completion(nil)
                        }
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
