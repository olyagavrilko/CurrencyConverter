//
//  Validator.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 18.07.2022.
//

import Foundation

enum Validator {
    
    static func reachedLimit(_ number: String) -> Bool {
        if number.contains(String.comma) {
            let fractionPart = number.split().fraction
            return fractionPart.count == AppConsts.maxFractionDigitCount ||
                   number.count == AppConsts.maxDigitCount + 1
        } else {
            return number.count == AppConsts.maxDigitCount
        }
    }
    
    static func reachedLimitForComma(_ number: String) -> Bool {
        number.contains(String.comma) || number.count == AppConsts.maxDigitCount
    }
}
