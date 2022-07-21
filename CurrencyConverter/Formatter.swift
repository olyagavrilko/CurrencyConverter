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
        
//        var integerDigits: String = "1234567890"
//        let isFractional: Bool
        
//        if unformatted.contains(String.comma) {
//            let components = unformatted.split(separator: Character(.comma)).map { String($0) }
//            let integerDigits = components[0]
//
//        }
        
        
        if unformatted.contains(String.comma) && unformatted.count > AppConsts.maxInputCharacterCount + 1 {
            let components = unformatted.split(separator: Character(.comma)).map { String($0) }
            let integerDigits = components[0]
//            let fractionDigits = components[1]
//            let maxFractionDigits = 9 - integerDigits.count
            
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
//        formatter.usesSignificantDigits = true
//        formatter.maximumSignificantDigits = 4
        formatter.maximumFractionDigits = 2
        
//        var toFormat = unformatted
        
//        if unformatted.contains(String.comma) {
//            toFormat = unformatted.replacingOccurrences(of: String.comma, with: ".")
//        }
        
//        guard let doubleValue = try Formatter.formatToDouble(unformatted) else {
//            throw ConversionFailure.decimal
//        }
        
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
