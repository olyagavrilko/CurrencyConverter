//
//  StateMachine.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 14.07.2022.
//

import Foundation

private extension String {
    static let zero = "0"
    static let zeroWithComma = "0,"
}

// TODO: Ограничить ввод запятой, если уже введено 9 цифр (сделала в валидаторе)

enum StateMachine {
    
    static func reduce(state: State, action: Action) throws -> State {
        
        switch state {
            
        case .initial:
            switch action {
            case .number(let value):
                return value == .zero ? .initial : .firstInput(value)
            case .operation(let operation):
                return .operation(.zero, operation)
            case .comma:
                return .firstInput(.zeroWithComma)
            case .percent, .equal, .cancel:
                return .initial
            }
            
        case .firstInput(let number):
            switch action {
            case .number(let value):
                let verifiedNumber = Validator.validateForInput(number: number, digit: value)
                return .firstInput(verifiedNumber)
            case .operation(let operation):
                return .operation(number, operation)
            case .comma:
                let verifiedNumber = Validator.validateForComma(number: number)
                return .firstInput(verifiedNumber)
            case .percent:
                let result = try Calculator.calculate(
                    first: Formatter.formatToDouble(number),
                    second: 100,
                    operation: .divide)
                return .firstInput(try Formatter.formatToString(result))
            case .equal:
                return .firstInput(number)
            case .cancel:
                return .initial
            }
            
        case let .operation(number, operation):
            switch action {
            case .number(let value):
                return .secondInput(first: number, second: value, operation)
            case .operation(let operation):
                return .operation(number, operation)
            case .comma:
                return .secondInput(first: number, second: .zeroWithComma, operation)
            case .percent:
                if operation.isPrimary {
                    let percent = try Calculator.calculate(
                        first: Formatter.formatToDouble(number),
                        second: 100,
                        operation: .divide)
                    return .secondInput(first: number, second: try Formatter.formatToString(percent), operation)
                } else {
                    let intermediateResultForPersent = try Calculator.calculate(first: Formatter.formatToDouble(number), second: Formatter.formatToDouble(number), operation: .multiply)
                    
                    let percent = try Calculator.calculate(
                        first: intermediateResultForPersent,
                        second: 100,
                        operation: .divide)
                    return .secondInput(first: number, second: try Formatter.formatToString(percent), operation)
                }
            case .equal:
                let result = try Calculator.calculate(
                    first: Formatter.formatToDouble(number),
                    second: Formatter.formatToDouble(number),
                    operation: operation)
                return .finish(try Formatter.formatToString(result), previousOperand: number, previousOperation: operation)
            case .cancel:
                return .initial
            }
            
        case let .secondInput(first, second, operation):
            switch action {
            case .number(let value):
                let verifiedNumber = Validator.validateForInput(number: second, digit: value)
                return .secondInput(first: first, second: verifiedNumber, operation)
            case .operation(let secondOperation):
                if !operation.isPrimary && secondOperation.isPrimary {
                    return .secondOperation(
                        first: first,
                        second: second,
                        firstOperation: operation,
                        secondOperation: secondOperation)
                } else {
                    let result = try Calculator.calculate(
                        first: Formatter.formatToDouble(first),
                        second: Formatter.formatToDouble(second),
                        operation: operation)
                    return .operation(try Formatter.formatToString(result), secondOperation)
                }
            case .comma:
                let verifiedNumber = Validator.validateForComma(number: second)
                return .secondInput(first: first, second: verifiedNumber, operation)
            case .percent:
                let intermediateResultForPercent = try Calculator.calculate(
                    first: Formatter.formatToDouble(first),
                    second: Formatter.formatToDouble(second),
                    operation: .multiply)
                let percent = try Calculator.calculate(
                    first: intermediateResultForPercent,
                    second: 100,
                    operation: .divide)
                return .secondInput(first: first, second: try Formatter.formatToString(percent), operation)
            case .equal:
                let result = try Calculator.calculate(
                    first: Formatter.formatToDouble(first),
                    second: Formatter.formatToDouble(second),
                    operation: operation)
                
                return .finish(try Formatter.formatToString(result), previousOperand: second, previousOperation: operation)
            case .cancel:
                return .initial
            }
            
        case let .secondOperation(first, second, firstOperation, secondOperation):
            switch action {
            case .number(let value):
                return .thirdInput(
                    first: first,
                    second: second,
                    third: value,
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .operation(let operation):
                return .secondOperation(
                    first: first,
                    second: second,
                    firstOperation: firstOperation,
                    secondOperation: operation)
            case .comma:
                return .thirdInput(
                    first: first,
                    second: second,
                    third: .zeroWithComma,
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .percent:
                    let intermediateResultForPercent = try Calculator.calculate(
                        first: Formatter.formatToDouble(second),
                        second: Formatter.formatToDouble(second),
                        operation: .multiply)
                    let percent = try Calculator.calculate(
                        first: intermediateResultForPercent,
                        second: 100,
                        operation: .divide)
                    return .secondInput(
                        first: first,
                        second: try Formatter.formatToString(percent),
                        firstOperation)
            case .equal:
                let intermediateResult = try Calculator.calculate(
                    first: Formatter.formatToDouble(second),
                    second: Formatter.formatToDouble(second),
                    operation: secondOperation)
                
                let result = try Calculator.calculate(
                    first: Formatter.formatToDouble(first),
                    second: intermediateResult,
                    operation: firstOperation)
                
                return .finish(try Formatter.formatToString(result), previousOperand: second, previousOperation: secondOperation)
            case .cancel:
                return .initial
            }
            
        case let .thirdInput(first, second, third, firstOperation, secondOperation):
            switch action {
            case .number(let value):
                let verifiedNumber = Validator.validateForInput(number: third, digit: value)
                
                return .thirdInput(
                    first: first,
                    second: second,
                    third: verifiedNumber,
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .operation(let thirdOperation):
                if thirdOperation.isPrimary {
                    let secondNumber = try Calculator.calculate(
                        first: Formatter.formatToDouble(second),
                        second: Formatter.formatToDouble(third),
                        operation: secondOperation)
                    
                    return .secondOperation(
                        first: first,
                        second: try Formatter.formatToString(secondNumber),
                        firstOperation: firstOperation,
                        secondOperation: thirdOperation)
                } else {
                    let secondNumber = try Calculator.calculate(
                        first: Formatter.formatToDouble(second),
                        second: Formatter.formatToDouble(third),
                        operation: secondOperation)
        
                    let finishNumber = try Calculator.calculate(
                        first: Formatter.formatToDouble(first),
                        second: secondNumber,
                        operation: firstOperation)
                    
                    return .operation(try Formatter.formatToString(finishNumber), thirdOperation)
                }
            case .comma:
                let verifiedNumber = Validator.validateForComma(number: third)
                return .thirdInput(
                    first: first,
                    second: second,
                    third: verifiedNumber,
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .percent:
                let intermediateResultForPercent = try Calculator.calculate(
                    first: Formatter.formatToDouble(second),
                    second: Formatter.formatToDouble(third),
                    operation: secondOperation)
                
                let percent = try Calculator.calculate(
                    first: intermediateResultForPercent,
                    second: 100,
                    operation: .divide)
                
                return .secondInput(first: first, second: try Formatter.formatToString(percent), firstOperation)
            case .equal:
                let intermediateResult = try Calculator.calculate(
                    first: Formatter.formatToDouble(second),
                    second: Formatter.formatToDouble(third),
                    operation: secondOperation)
                
                let result = try Calculator.calculate(
                    first: Formatter.formatToDouble(first),
                    second: intermediateResult,
                    operation: firstOperation)
                
                return .finish(
                    try Formatter.formatToString(result),
                    previousOperand: third,
                    previousOperation: secondOperation)
            case .cancel:
                return .initial
            }
            
        case let .finish(finishValue, previousOperand, previousOperation):
            switch action {
            case .number(let value):
                return .firstInput(value)
            case .operation(let operation):
                return .operation(finishValue, operation)
            case .comma:
                return .firstInput(.zeroWithComma)
            case .percent:
                let percent = try Calculator.calculate(
                    first: Formatter.formatToDouble(finishValue),
                    second: 100,
                    operation: .divide)
                return .firstInput(try Formatter.formatToString(percent))
            case .equal:
                let newNumber = try Calculator.calculate(
                    first: Formatter.formatToDouble(finishValue),
                    second: Formatter.formatToDouble(previousOperand),
                    operation: previousOperation)
                return .finish(
                    try Formatter.formatToString(newNumber),
                    previousOperand: previousOperand,
                    previousOperation: previousOperation)
            case .cancel:
                return State.initial
            }
            
        case .error:
            switch action {
            case .number(let value):
                return .firstInput(value)
            case .operation:
                return .error
            case .comma:
                return .firstInput(.zeroWithComma)
            case .percent:
                return .error
            case .equal:
                return .error
            case .cancel:
                return .initial
            }
        }
    }
}
