//
//  Formatter.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 18.07.2022.
//

import Foundation

// TODO: На втором вводе не вводится сотая часть числа

enum Formatter {
    
    enum ConversionFailure: Error {
        case double
        case string
        case decimal
        case scientific
    }
    
    static func formatToDouble(_ unformatted: String) throws -> Double {
        guard let doubleValue = Double(unformatted.replacingOccurrences(of: ",", with: ".")) else {
            throw ConversionFailure.double
        }
        return doubleValue
    }
    
    static func formatToString(_ unformatted: Double) throws -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: unformatted)
        formatter.maximumFractionDigits = 10
        
        guard let result = formatter.string(from: number) else {
            throw ConversionFailure.string
        }
        
        return result.replacingOccurrences(of: ".", with: String.comma)
    }
    
    static func format(_ unformatted: String) throws -> String {
        
        if unformatted.contains(String.comma) && unformatted.count > AppConsts.maxInputCharacterCount + 1 {
            let components = unformatted.split(separator: Character(.comma)).map { String($0) }
            let integerDigits = components[0]
            
            if integerDigits.count < 9 {
                return try formatToDecimalStyle(unformatted)
            } else {
                return try formatToScientificStyle(unformatted)
            }
            
            
        } else if unformatted.count <= AppConsts.maxInputCharacterCount ||
                    unformatted.contains(String.comma) && unformatted.count <= AppConsts.maxInputCharacterCount + 1 {
            return try formatToDecimalStyle(unformatted)
        } else {
            return try formatToScientificStyle(unformatted)
        }
    }
    
    static func formatToDecimalStyle(_ unformatted: String) throws -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        
        let number = NSNumber(value: try Formatter.formatToDouble(unformatted))
        
        guard let result = formatter.string(from: number) else {
            throw ConversionFailure.decimal
        }
        
        return result.replacingOccurrences(of: ".", with: String.comma)
    }
    
    static func formatToScientificStyle(_ unformatted: String) throws -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.exponentSymbol = "e"
        formatter.usesSignificantDigits = true
        let number = NSNumber(value: try formatToDouble(unformatted))
        
        guard let result = formatter.string(from: number) else {
            throw ConversionFailure.scientific
        }
        return result.replacingOccurrences(of: ".", with: String.comma)
    }
}
