//
//  Action.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 31.07.2022.
//

import Foundation

enum Action {
    case number(String)
    case operation(Operation)
    case comma
    case percent
    case equal
    case cancel
}
