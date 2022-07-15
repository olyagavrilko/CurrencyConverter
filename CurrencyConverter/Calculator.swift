//
//  Calculator.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 14.07.2022.
//

import Foundation

enum Calculator {
    
    enum Failure: Error {
        case divideOnZero
    }
    
    static func calculate(first: Double, second: Double, operation: Operation) throws -> Double {
        switch operation {
        case .add:
            return first + second
        case .subtract:
            return first - second
        case .multiply:
            return first * second
        case .divide:
            guard second != .zero else {
                throw Failure.divideOnZero
            }
            return first / second
        }
    }
}
