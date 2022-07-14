//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

//class KeyboardNumberButton: UIButton {
//
//    enum Value {
//        case zero
//        case one
//        case two
//        case three
//        case four
//        case five
//        case six
//        case seven
//        case eight
//        case nine
//
//        var title: String {
//            switch self {
//            case .zero:
//                return "0"
//            case .one:
//                return "1"
//            case .two:
//                return "2"
//            case .three:
//                return "3"
//            case .four:
//                return "4"
//            case .five:
//                return "5"
//            case .six:
//                return "6"
//            case .seven:
//                return "7"
//            case .eight:
//                return "8"
//            case .nine:
//                return "9"
//            }
//        }
//    }
//
//    let value: Value
//
//    init(value: Value) {
//        self.value = value
//        super.init()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//enum Input {
//    case value(Double) // 5
//    case comma(value: Int) // 5,
//    case zeroes(value: Double, count: Int)
//}

//struct Input: Equatable {
//    let value: Double
//    let hasComma: Bool
//    let zeroCount: Int
//
//    var stringValue: String {
//        return ""
//    }
//
//    func add(_ character: String) {
//
//    }
//}

final class MainViewModel {
    
    enum Operation: String {
        case add = "􀅼"
        case subtract = "􀅽"
        case multiply = "􀅾"
        case divide = "􀅿"
    }
    
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
    
    enum Action {
        case number(String)
        case operation(Operation)
        case comma
        case equal
//        case percent
        case cancel
    }
    
    weak var view: MainViewController?
    
    var currentState: State = .initial {
        didSet {
            view?.update(text: makeText(using: currentState))
        }
    }
    
    func makeText(using state: State) -> String {
        switch state {
        case .initial:
            return "0"
        case .firstInput(let value):
            return spacingFormat(value)
        case .operation(let value, _):
            return spacingFormat(value)
        case .secondInput(first: _, second: let second, _):
            return spacingFormat(second)
        case .secondOperation(first: let first, second: let second, firstOperation: let firstOperation, secondOperation: let secondOperation):
            return spacingFormat(second)
        case .thirdInput(first: let first, second: let second, third: let third, firstOperation: let firstOperation, secondOperation: let secondOperation):
            return spacingFormat(third)
        case .finish(let value, _, _):
            return spacingFormat(value)
        case .error:
            return "Ошибка"
        }
    }
    
    func reduce(state: State, action: Action) -> State {
        switch state {
            
        case .initial:
            switch action {
            case .number(let value):
                if value == "0" {
                    return State.initial
                } else {
                    return State.firstInput(value)
                }
            case .operation(let operation):
                return State.operation("0", operation)
            case .comma:
                return State.firstInput("0,")
            case .equal, .cancel:
                return State.initial
            }
            
        case .firstInput(let number):
            switch action {
            case .number(let value):
// TODO: Ограничить количество вводимых цифр
                let newNumber = number + value
                return State.firstInput(newNumber)
            case .operation(let operation):
                return State.operation(number, operation)
            case .comma:
                if number.contains(",") {
                    return State.firstInput(number)
                } else {
                    return State.firstInput(number + ",")
                }
            case .equal:
                return State.firstInput(number)
            case .cancel:
                return State.initial
            }
            
        case .operation(let number, let operation):
            switch action {
            case .number(let value):
                return State.secondInput(first: number, second: value, operation)
            case .operation(let operation):
                return State.operation(number, operation)
            case .comma:
                return State.secondInput(first: number, second: "0,", operation)
            case .equal:
                guard let numberDoubleValue = number.doubleValue else {
                    return State.error
                }
                let newNumber = calculate(firstOperand: numberDoubleValue, secondOperand: numberDoubleValue, operation: operation)
                return State.finish(newNumber.stringValue, previousOperand: number, previousOperation: operation)
            case .cancel:
                return State.initial
            }
            
        case .secondInput(let firstNumber, let secondNumber, let operation):
            switch action {
            case .number(let value):
                let newNumber = secondNumber + value
                return State.secondInput(first: firstNumber, second: newNumber, operation)
            case .operation(let newOperation):
                guard let firstNumberDouble = firstNumber.doubleValue, let secondNumberDouble = secondNumber.doubleValue else {
                    return State.error
                }
                
                let newNumber = calculate(firstOperand: firstNumberDouble, secondOperand: secondNumberDouble, operation: operation)
                
                if secondNumber == "0" && operation == .divide {
                    return .error
                } else if (operation == .add || operation == .subtract) && (newOperation == .multiply || newOperation == .divide) {
                    return .secondOperation(first: firstNumber, second: secondNumber, firstOperation: operation, secondOperation: newOperation)
                } else {
                    return State.operation(String(newNumber), newOperation)
                }
            case .comma:
                return State.secondInput(first: firstNumber, second: secondNumber + ",", operation)
            case .equal:
                guard let firstNumberDouble = firstNumber.doubleValue,
                      let secondNumberDouble = secondNumber.doubleValue
                else {
                    return State.initial
                }
                
                let newNumber = calculate(firstOperand: firstNumberDouble, secondOperand: secondNumberDouble, operation: operation)
                
                if secondNumber == "0" && operation == .divide {
                    return .error
                } else {
                    return State.finish(newNumber.stringValue, previousOperand: secondNumber, previousOperation: operation)
                }
            case .cancel:
                return State.initial
            }
            
        case .secondOperation(first: let first, second: let second, firstOperation: let firstOperation, secondOperation: let secondOperation):
            switch action {
            case .number(let value):
                return .thirdInput(first: first, second: second, third: value, firstOperation: firstOperation, secondOperation: secondOperation)
            case .operation(let operation):
                return .secondOperation(first: first, second: second, firstOperation: firstOperation, secondOperation: operation)
            case .comma:
                return .thirdInput(first: first, second: second, third: "0,", firstOperation: firstOperation, secondOperation: secondOperation)
            case .equal:
                guard let firstDouble = first.doubleValue, let secondDouble = second.doubleValue else {
                    return .error
                }
                
                if (firstOperation == .add || firstOperation == .subtract) && (secondOperation == .multiply || secondOperation == .divide) {
                    
                    let secondNumber = calculate(firstOperand: secondDouble, secondOperand: secondDouble, operation: secondOperation)
                    
                    let finishNumber = calculate(firstOperand: firstDouble, secondOperand: secondNumber, operation: firstOperation)
                    
                    return .finish(finishNumber.stringValue, previousOperand: second, previousOperation: secondOperation)
                } else {
                    let firstNumber = calculate(firstOperand: firstDouble, secondOperand: secondDouble, operation: firstOperation)
                    
                    let finishNumber = calculate(firstOperand: firstNumber, secondOperand: firstNumber, operation: secondOperation)
                    
                    return .finish(finishNumber.stringValue, previousOperand: firstNumber.stringValue, previousOperation: secondOperation)
                }
            case .cancel:
                return .initial
            }
            
        case .thirdInput(first: let first, second: let second, third: let third, firstOperation: let firstOperation, secondOperation: let secondOperation):
            
            guard let firstDouble = first.doubleValue,
                  let secondDouble = second.doubleValue,
                  let thirdDouble = third.doubleValue else {
                return .error
            }
            
            switch action {
            case .number(let value):
                let newNimber = third + value
                return .thirdInput(
                    first: first,
                    second: second,
                    third: newNimber,
                    firstOperation: firstOperation,
                    secondOperation: secondOperation)
            case .operation(let operation):
                if third == "0" && secondOperation == .divide {
                    return .error
                } else if operation == .subtract || operation == .add {
                    
                    if (firstOperation == .add || firstOperation == .subtract) && (secondOperation == .multiply || secondOperation == .divide) {
                        
                        let secondNumber = calculate(firstOperand: secondDouble, secondOperand: thirdDouble, operation: secondOperation)
                        
                        let finishNumber = calculate(firstOperand: firstDouble, secondOperand: secondNumber, operation: firstOperation)
                        
                        return .operation(finishNumber.stringValue, operation)
                    } else {
                        
                        let firstNumber = calculate(firstOperand: firstDouble, secondOperand: secondDouble, operation: firstOperation)
                        
                        let finishNumber = calculate(firstOperand: firstNumber, secondOperand: thirdDouble, operation: secondOperation)
                        
                        return .operation(finishNumber.stringValue, operation)
                    }
                } else if operation == .multiply || operation == .divide {
                    
                    if (firstOperation == .add || firstOperation == .subtract) && (secondOperation == .multiply || secondOperation == .divide) {
                        
                        let secondNumber = calculate(firstOperand: secondDouble, secondOperand: thirdDouble, operation: secondOperation)
                        
                        return .secondOperation(first: first, second: secondNumber.stringValue, firstOperation: firstOperation, secondOperation: operation)
                    } else {
                        
                        let firstNumber = calculate(firstOperand: firstDouble, secondOperand: secondDouble, operation: firstOperation)
                        
                        return .secondOperation(first: firstNumber.stringValue, second: second, firstOperation: secondOperation, secondOperation: operation)
                    }
                }
            case .comma:
                return .thirdInput(first: first, second: second, third: third + ",", firstOperation: firstOperation, secondOperation: secondOperation)
            case .equal:
                if third == "0" && secondOperation == .divide {
                    return .error
                } else if (firstOperation == .add || firstOperation == .subtract) && (secondOperation == .multiply || secondOperation == .divide) {
                    let secondNumber = calculate(firstOperand: secondDouble, secondOperand: thirdDouble, operation: secondOperation)
                    
                    let finishNumber = calculate(firstOperand: firstDouble, secondOperand: secondNumber, operation: firstOperation)
                    
                    return .finish(finishNumber.stringValue, previousOperand: third, previousOperation: secondOperation)
                } else {
                    let firstNumber = calculate(firstOperand: firstDouble, secondOperand: secondDouble, operation: firstOperation)
                    
                    let finishNumber = calculate(firstOperand: firstNumber, secondOperand: thirdDouble, operation: secondOperation)
                    
                    return .finish(finishNumber.stringValue, previousOperand: third, previousOperation: secondOperation)
                }
            case .cancel:
                return .initial
            }
            
        case .finish(let finishValue, previousOperand: let previousOperand, previousOperation: let previousOperation):
            switch action {
            case .number(let value):
                return State.firstInput(value)
            case .operation(let operation):
                return State.operation(finishValue, operation)
            case .comma:
                return .firstInput("0,")
            case .equal:
                guard let finishValueDouble = finishValue.doubleValue,
                      let previousOperandDouble = previousOperand.doubleValue else {
                    return .error
                }
                
                let newNumber = calculate(firstOperand: finishValueDouble, secondOperand: previousOperandDouble, operation: previousOperation)
                return .finish(newNumber.stringValue, previousOperand: previousOperand, previousOperation: previousOperation)
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
                return .firstInput("0,")
            case .equal:
                return .error
            case .cancel:
                return .initial
            }
        }
    }
    
    func buttonTapped(with value: String) {
        let action = makeAction(using: value)
        currentState = reduce(state: currentState, action: action)
    }
    
    func makeAction(using value: String) -> Action {
        if "0123456789".contains(value) {
            return Action.number(value)
        } else if "􀅿􀅾􀅼􀅽".contains(value) {
            if value == "􀅼" {
                return Action.operation(.add)
            } else if value == "􀅽" {
                return Action.operation(.subtract)
            } else if value == "􀅾" {
                return Action.operation(.multiply)
            } else if value == "􀅿" {
                return Action.operation(.divide)
            }
        } else if value == "," {
            return Action.comma
        } else if value == "􀆀" {
            return Action.equal
        } else if value == "C" {
            return Action.cancel
        }
        return Action.cancel
    }
    
    func spacingFormat(_ unformatted: String) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        
        var toFormat = ""
        var formatted = ""
        
        if unformatted.contains(",") {
            let components = unformatted.split(separator: ",").map { String($0) }
            toFormat = components[0]
            formatted = ","
            if components.count > 1 {
                formatted += components[1]
            }
        } else {
            toFormat = unformatted
        }
        
        guard let doubleValue = Double(toFormat) else {
            return ""
        }
        
        let number = NSNumber(value: doubleValue)
        
        let s = String(formatter.string(from: number) ?? "")
        formatted = s + formatted
        return formatted.replacingOccurrences(of: ".", with: ",")
    }
    
    func calculate(firstOperand: Double, secondOperand: Double, operation: Operation) -> Double {
        switch operation {
        case .add:
            let newNumber = firstOperand + secondOperand
            return newNumber
        case .subtract:
            let newNumber = firstOperand - secondOperand
            return newNumber
        case .multiply:
            let newNumber = firstOperand * secondOperand
            return newNumber
        case .divide:
            let newNumber = firstOperand / secondOperand
            return newNumber
        }
    }
}
