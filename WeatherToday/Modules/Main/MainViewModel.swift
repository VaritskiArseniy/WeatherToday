//
//  MainViewModel.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 20.07.24.
//

import Foundation

protocol MainViewModelInterface { }

class MainViewModel {
    
    weak var view: MainViewControllerInterface?
    private weak var output: MainOutput?
    
    
    init(output: MainOutput) {
        self.output = output
    }
}

extension MainViewModel: MainViewModelInterface { }
