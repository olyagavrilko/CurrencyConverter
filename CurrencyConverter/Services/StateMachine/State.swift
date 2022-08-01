//
//  State.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 31.07.2022.
//

import Foundation

enum State: Equatable {
    case initial
    case firstInput(String)
    case operation(String, Operation)
    case secondInput(first: String, second: String, Operation)
    case secondOperation(first: String, second: String, firstOperation: Operation, secondOperation: Operation)
    case thirdInput(first: String, second: String, third: String, firstOperation: Operation, secondOperation: Operation)
    case finish(String, previousOperand: String, previousOperation: Operation)
    case error
}
