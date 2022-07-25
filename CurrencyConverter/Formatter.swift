//
//  Formatter.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 18.07.2022.
//

import Foundation

private extension String {
    static let doubleZero = "00"
}

enum Formatter {
    
    enum ConversionFailure: Error {
        case double
        case string
        case decimal
        case scientific
    }
    
    static func formattedOutput(_ unformatted: String) throws -> String {
        if unformatted.contains(Character(.comma)) {
            let (integer, fraction) = unformatted.split()
            
            if integer.count + fraction.count > AppConsts.maxDigitCount {
                return try formatToScientificStyle(unformatted)
            } else {
                return try formatToDecimalStyle(unformatted)
            }
        } else {
            if unformatted.count > AppConsts.maxDigitCount {
                return try formatToScientificStyle(unformatted)
            } else {
                return try formatToDecimalStyle(unformatted)
            }
        }
    }
    
    static func formatToDouble(_ unformatted: String) throws -> Double {
        guard let doubleValue = Double(
            unformatted
                .replacingOccurrences(of: ",", with: ".")
                .replacingOccurrences(of: " ", with: ""))
        else {
            throw ConversionFailure.double
        }
        return doubleValue
    }
    
    static func formatToString(_ unformatted: Double) throws -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: unformatted)
        formatter.maximumFractionDigits = AppConsts.maxFractionDigitCount
        
        guard let result = formatter.string(from: number) else {
            throw ConversionFailure.string
        }
        
        return result.replacingOccurrences(of: ".", with: String.comma)
    }
    
    static func formatToDecimalStyle(_ unformatted: String) throws -> String {
        
        let (integer, fraction) = unformatted.split()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        
        let number = NSNumber(value: try Formatter.formatToDouble(integer))
        
        guard var result = formatter.string(from: number) else {
            throw ConversionFailure.decimal
        }
        
        if !fraction.isEmpty {
            result += .comma + fraction
        } else if unformatted.hasSuffix(.comma) {
            result += .comma
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
