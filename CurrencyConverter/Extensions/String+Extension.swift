//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

extension String {
    
    enum ConversionFailure: Error {
        case double
    }
    
    func doubleValue() throws -> Double {
        guard let doubleValue = Double(replacingOccurrences(of: ",", with: ".")) else {
            throw ConversionFailure.double
        }
        return doubleValue
    }
}
