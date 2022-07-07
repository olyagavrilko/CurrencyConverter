//
//  Double+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

extension Double {
    var stringValue: String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let s = String(formatter.string(from: number) ?? "")
        return s.replacingOccurrences(of: ".", with: ",")
    }
}
