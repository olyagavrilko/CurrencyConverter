//
//  CurrencySelectionViewModel.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 27.07.2022.
//

import Foundation

protocol CurrencySelectionViewModelDelegate: AnyObject {
    
}

final class CurrencySelectionViewModel {
    
    let currencyArray = ["RUB", "USD", "EUR"]
    
    weak var delegate: CurrencySelectionViewModelDelegate?
    let completion: (String) -> Void
    
    init(completion: @escaping (String) -> Void) {
        self.completion = completion
    }
    
    func currencySelected(_ currency: Int) {
        completion(currencyArray[currency])
    }
}
