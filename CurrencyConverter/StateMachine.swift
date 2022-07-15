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
    static let comma = ","
}

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
            case .equal, .cancel:
                return .initial
            }
            
        case .firstInput(let number):
            switch action {
            case .number(let value):
                return .firstInput(number + value) // TODO: Ограничить количество вводимых цифр
            case .operation(let operation):
                return .operation(number, operation)
            case .comma:
                return number.contains(String.comma) ? .firstInput(number) : .firstInput(number + .comma)
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
            case .equal:
                let result = try Calculator.calculate(
                    first: try number.doubleValue(),
                    second: try number.doubleValue(),
                    operation: operation)
                return .finish(result.stringValue, previousOperand: number, previousOperation: operation)
            case .cancel:
                return .initial
            }
            
        case let .secondInput(first, second, operation):
            switch action {
            case .number(let value):
                return .secondInput(first: first, second: second + value, operation)
            case .operation(let secondOperation):
                let result = try Calculator.calculate(
                    first: try first.doubleValue(),
                    second: try second.doubleValue(),
                    operation: operation)
                
                if !operation.isPrimary && secondOperation.isPrimary {
                    return .secondOperation(
                        first: first,
                        second: second,
                        firstOperation: operation,
                        secondOperation: secondOperation)
                } else {
                    return .operation(result.stringValue, secondOperation)
                }
            case .comma:
                return .secondInput(first: first, second: second + .comma, operation)
            case .equal:
                let result = try Calculator.calculate(
                    first: try first.doubleValue(),
                    second: try second.doubleValue(),
                    operation: operation)
                
                return .finish(result.stringValue, previousOperand: second, previousOperation: operation)
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
            case .equal:
                if !firstOperation.isPrimary && secondOperation.isPrimary {
                    
                    let intermediateResult = try Calculator.calculate(
                        first: try second.doubleValue(),
                        second: try second.doubleValue(),
                        operation: secondOperation)
                    
                    let result = try Calculator.calculate(
                        first: try first.doubleValue(),
                        second: intermediateResult,
                        operation: firstOperation)
                    
                    return .finish(result.stringValue, previousOperand: second, previousOperation: secondOperation)
                } else {
                    let intermediateResult = try Calculator.calculate(
                        first: try first.doubleValue(),
                        second: try second.doubleValue(),
                        operation: firstOperation)
                    
                    let result = try Calculator.calculate(
                        first: intermediateResult,
                        second: intermediateResult,
                        operation: secondOperation)
                    
                    return .finish(
                        result.stringValue,
                        previousOperand: intermediateResult.stringValue,
                        previousOperation: secondOperation)
                }
            case .cancel:
                return .initial
            }
            
        case let .thirdInput(first, second, third, firstOperation, secondOperation):
            switch action {
            case .number(let value):
                return .thirdInput(
                    first: first,
                    second: second,
                    third: third + value,
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .operation(let thirdOperation):
                if thirdOperation.isPrimary {
                    
                    let secondNumber = try Calculator.calculate(
                        first: try second.doubleValue(),
                        second: try third.doubleValue(),
                        operation: secondOperation)
                    
                    return .secondOperation(
                        first: first,
                        second: secondNumber.stringValue,
                        firstOperation: firstOperation,
                        secondOperation: thirdOperation)

//                    if !firstOperation.isPrimary && secondOperation.isPrimary {
//                        let secondNumber = try Calculator.calculate(
//                            first: try second.doubleValue(),
//                            second: try third.doubleValue(),
//                            operation: secondOperation)
//
//                        return .secondOperation(
//                            first: first,
//                            second: secondNumber.stringValue,
//                            firstOperation: firstOperation,
//                            secondOperation: thirdOperation)
//                    } else {
//                        let firstNumber = calculate(firstOperand: firstDouble, secondOperand: secondDouble, operation: firstOperation)
//
//                        return .secondOperation(first: firstNumber.stringValue, second: second, firstOperation: secondOperation, secondOperation: thirdOperation)
//                    }
                    
                } else {
                    
                    let secondNumber = try Calculator.calculate(
                        first: try second.doubleValue(),
                        second: try third.doubleValue(),
                        operation: secondOperation)
                    
                    let finishNumber = try Calculator.calculate(
                        first: try first.doubleValue(),
                        second: secondNumber,
                        operation: firstOperation)
                    
                    return .operation(finishNumber.stringValue, thirdOperation)
                    
//                    if !firstOperation.isPrimary && secondOperation.isPrimary {
//
//                        let secondNumber = calculate(firstOperand: secondDouble, secondOperand: thirdDouble, operation: secondOperation)
//
//                        let finishNumber = calculate(firstOperand: firstDouble, secondOperand: secondNumber, operation: firstOperation)
//
//                        return .operation(finishNumber.stringValue, thirdOperation)
//                    } else {
//
//                        let firstNumber = calculate(firstOperand: firstDouble, secondOperand: secondDouble, operation: firstOperation)
//
//                        let finishNumber = calculate(firstOperand: firstNumber, secondOperand: thirdDouble, operation: secondOperation)
//
//                        return .operation(finishNumber.stringValue, thirdOperation)
//                    }
                }
                
                
                
                
            case .comma:
                return .thirdInput(
                    first: first,
                    second: second,
                    third: third + ",",
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .equal:
                if !firstOperation.isPrimary && secondOperation.isPrimary {
                    let secondNumber = try Calculator.calculate(
                        first: try second.doubleValue(),
                        second: try third.doubleValue(),
                        operation: secondOperation)
                    
                    let finishNumber = try Calculator.calculate(
                        first: try first.doubleValue(),
                        second: secondNumber,
                        operation: firstOperation)
                    
                    return .finish(
                        finishNumber.stringValue,
                        previousOperand: third,
                        previousOperation: secondOperation)
                } else {
                    let firstNumber = try Calculator.calculate(
                        first: try first.doubleValue(),
                        second: try second.doubleValue(),
                        operation: firstOperation)
                    
                    let finishNumber = try Calculator.calculate(
                        first: firstNumber,
                        second: try third.doubleValue(),
                        operation: secondOperation)
                    
                    return .finish(
                        finishNumber.stringValue,
                        previousOperand: third,
                        previousOperation: secondOperation)
                }
            case .cancel:
                return .initial
            }
            
        case let .finish(finishValue, previousOperand, previousOperation):
            switch action {
            case .number(let value):
                return State.firstInput(value)
            case .operation(let operation):
                return State.operation(finishValue, operation)
            case .comma:
                return .firstInput(.zeroWithComma)
            case .equal:
                let newNumber = try Calculator.calculate(
                    first: try finishValue.doubleValue(),
                    second: try previousOperand.doubleValue(),
                    operation: previousOperation)
                return .finish(
                    newNumber.stringValue,
                    previousOperand: previousOperand,
                    previousOperation: previousOperation)
            case .cancel:
                return State.initial
            }
            
        case .error:
            switch action {
            case .number(let value):
                return .firstInput(value)
            case .operation(_):
                return .error
            case .comma:
                return .firstInput(.zeroWithComma)
            case .equal:
                return .error
            case .cancel:
                return .initial
            }
        }
    }
}
