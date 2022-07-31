//
//  MainAssembly.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

final class MainAssembly {
    
    func assemble() -> MainViewController {
        let router = MainRouter()
        let networkService = NetworkService()
        let viewModel = MainViewModel(router: router, networkService: networkService)
        let viewController = MainViewController(viewModel: viewModel)
        
        router.viewController = viewController
        viewModel.delegate = viewController
        return viewController
    }
}
