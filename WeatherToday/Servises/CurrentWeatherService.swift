//
//  WeatherService.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 22.07.24.
//

import Foundation
import Alamofire

class CurrentWeatherService {
    let apiKey = "3443f5398bac843ff606f5305ad2fc9f"
    
    func fetchWeather(lat: String, lon: String, completion: @escaping (CurrentWeatherModel?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        AF.request(urlString).responseDecodable(of: CurrentWeatherModel.self) { response in
            switch response.result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                print("Error fetching weather: \(error)")
                completion(nil)
            }
        }
    }
}
