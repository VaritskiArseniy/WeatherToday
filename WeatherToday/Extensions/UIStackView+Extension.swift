//
//  UIStackView+Extension.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 23.07.24.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
