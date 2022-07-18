//
//  Validator.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 18.07.2022.
//

import Foundation

enum Validator {
    
    static func validateForInput(number: String, digit: String) -> String {
        if number.count < AppConsts.maxInputCharacterCount ||
            number.contains(String.comma) && number.count < AppConsts.maxInputCharacterCount + 1 {
            return number + digit
        } else {
            return number
        }
    }
    
    static func validateForComma(number: String) -> String {
        return number.contains(String.comma) ? number : number + .comma
    }
}
