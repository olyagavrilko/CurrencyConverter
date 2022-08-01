//
//  Operation.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 31.07.2022.
//

import Foundation

enum Operation: String {
    case add = "􀅼"
    case subtract = "􀅽"
    case multiply = "􀅾"
    case divide = "􀅿"
    
    var isPrimary: Bool {
        self == .multiply || self == .divide
    }
}
