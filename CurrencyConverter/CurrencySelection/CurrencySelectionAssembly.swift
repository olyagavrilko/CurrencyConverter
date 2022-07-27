//
//  CurrencySelectionAssembly.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 27.07.2022.
//

import Foundation

final class CurrencySelectionAssembly {
    
    func assemble(completion: @escaping (String) -> Void) -> CurrencySelectionViewController {
        let viewModel = CurrencySelectionViewModel(completion: completion)
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        
        viewModel.delegate = viewController
        return viewController
    }
}
