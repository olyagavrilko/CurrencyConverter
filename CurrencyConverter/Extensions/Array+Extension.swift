//
//  Array+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 24.07.2022.
//

import Foundation

extension Array {
    
    subscript(safe index: Int) -> Element? {
        
        guard index < count else {
            return nil
        }
        
        return self[index]
    }
}
