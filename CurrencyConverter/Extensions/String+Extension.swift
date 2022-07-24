//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

extension String {
    static let comma = ","
    static let zero = "0"
    
    func split() -> (integer: String, fraction: String) {
        let components = split(separator: Character(.comma)).map(String.init)
        return (integer: components[safe: 0] ?? "", fraction: components[safe: 1] ?? "")
    }
}
