//
//  String+Extension.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
