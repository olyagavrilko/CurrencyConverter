//
//  CurrencySelectionViewModel.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 27.07.2022.
//

import Foundation

final class CurrencySelectionViewModel {
    
    typealias Currency = (code: String, description: String)
    
    var currencies: [Currency] = []
    
    private let completion: (String) -> Void
    
    init(completion: @escaping (String) -> Void) {
        self.completion = completion
        self.currencies = self.fetchCurrenciesFromFile()
    }
    
    func currencySelected(_ index: Int) {
        completion(currencies[index].code)
    }
    
    private func fetchCurrenciesFromFile() -> [Currency] {
        
        guard let filepath = Bundle.main.path(forResource: "currencies", ofType: "json"),
              let string = try? String(contentsOfFile: filepath),
              let data = string.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        else {
            return []
        }
        return dict.map { (code: $0.key, description: $0.value) }
    }
}
