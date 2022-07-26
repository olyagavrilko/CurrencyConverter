//
//  MainAssembly.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

final class MainAssembly {
    
    func assemble() -> MainViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController(viewModel: viewModel)
        
        viewModel.delegate = viewController
        return viewController
    }
}
