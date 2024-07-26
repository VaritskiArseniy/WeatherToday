//
//  UIView+Extension.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 22.07.24.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
