//
//  Assembly.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 20.07.24.
//

import Foundation
import UIKit

final class Assembly {
    func makeMain(output: MainOutput) -> UIViewController {
        let viewModel = MainViewModel(output: output)
        let view = MainViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
}

