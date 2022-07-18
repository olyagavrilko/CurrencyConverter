//
//  Formatter.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 18.07.2022.
//

import Foundation

enum Formatter {
    
    enum ConversionFailure: Error {
        case double
        case decimal
        case scientific
    }
    
    static func formatToDouble(_ unformatted: String) throws -> Double {
        guard let doubleValue = Double(unformatted.replacingOccurrences(of: ",", with: ".")) else {
            throw ConversionFailure.double
        }
        return doubleValue
    }
    
    static func format(_ unformatted: String) throws -> String {
        
//        guard try formatToDouble(unformatted) <= Double.greatestFiniteMagnitude else {
//            return "Ошибка"
//        }
        
        if unformatted.count <= AppConsts.maxInputCharacterCount ||
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
        
        var toFormat = ""
        var formatted = ""
        
        if unformatted.contains(String.comma) {
            let components = unformatted.split(separator: Character(.comma)).map { String($0) }
            toFormat = components[0]
            formatted = String.comma
            if components.count > 1 {
                formatted += components[1]
            }
        } else {
            toFormat = unformatted
        }
        
        guard let doubleValue = Double(toFormat) else {
            throw ConversionFailure.decimal
        }
        
        let number = NSNumber(value: doubleValue)
        
        guard let result = formatter.string(from: number) else {
            throw ConversionFailure.decimal
        }
        formatted = result + formatted
        return formatted.replacingOccurrences(of: ".", with: String.comma)
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
