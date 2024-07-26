//
//  Coordinator.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 20.07.24.
//

import Foundation
import UIKit

final class Coordinator {
    
    private let assembly: Assembly
    private var navigationController = UINavigationController()
    
    init(assembly: Assembly) {
        self.assembly = assembly
    }
    
    func startMain(window: UIWindow) {
        let viewController = assembly.makeMain(output: self)
        navigationController = .init(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension Coordinator: MainOutput {
    
}
