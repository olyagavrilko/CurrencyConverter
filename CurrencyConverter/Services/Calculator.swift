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
        case overflow
    }
    
    static func calculate(first: Double, second: Double, operation: Operation) throws -> Double {
        
        let result: Double
        
        switch operation {
        case .add:
            result = first + second
        case .subtract:
            result = first - second
        case .multiply:
            result = first * second
        case .divide:
            guard second != .zero else {
                throw Failure.divideOnZero
            }
            result = first / second
        }
        
        guard result.isFinite else {
            throw Failure.overflow
        }
        
        return result
    }
}
