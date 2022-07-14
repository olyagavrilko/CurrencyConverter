//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

extension String {
    var doubleValue: Double? {
        if self.isEmpty || self == "Ошибка"  { return 0 }
        guard let doubleValue = Double(self.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")) else {
            return 0
        }
        return doubleValue
    }
    
    var format: String {
        if self.contains(".") {
            return self.replacingOccurrences(of: ".", with: ",")
        }
        return self
    }
}
