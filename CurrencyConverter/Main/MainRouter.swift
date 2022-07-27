//
//  MainRouter.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 27.07.2022.
//

import UIKit

final class MainRouter {
    
    weak var viewController: MainViewController?
    
    func openCurrencySelection(completion: @escaping (String) -> Void) {
        let currencyViewController = CurrencySelectionAssembly().assemble(completion: completion)
        viewController?.present(currencyViewController, animated: true)
    }
}
