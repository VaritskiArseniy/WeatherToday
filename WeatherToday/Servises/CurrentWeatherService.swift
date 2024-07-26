//
//  WeatherService.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 22.07.24.
//

import Foundation

class CurrentWeatherService {
    let apiKey = "3443f5398bac843ff606f5305ad2fc9f"
    
    func fetchWeather(lat: String, lon: String, completion: @escaping (CurrentWeatherModel?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
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
                    let weatherModel = CurrentWeatherModel(weatherJson: json)
                    completion(weatherModel)
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
