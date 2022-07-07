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

final class MainViewModel {
    
    enum Operation: String {
        case add = "􀅼"
        case subtract = "􀅽"
        case multiply = "􀅾"
        case divide = "􀅿"
    }
    
    enum State: Equatable {
        case initial
//        case inputComma(Double)
        case firstInput(Double)
        case operation(Double, Operation)
        case secondInput(first: Double, second: Double, Operation)
        case finish(Double, previousOperand: Double, previousOperation: Operation)
    }
    
    enum Action {
        case number(Double)
        case operation(Operation)
//        case comma
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
            return value.stringValue
        case .operation(let value, _):
            return value.stringValue
        case .secondInput(first: _, second: let second, _):
            return second.stringValue
        case .finish(let value, _, _):
            return value.stringValue
        }
    }
    
    func reduce(state: State, action: Action) -> State {
        switch state {
        case .initial:
            switch action {
            case .number(let value):
                return State.firstInput(value)
            case .operation, .equal, .cancel:
                return State.initial
            }
        case .firstInput(let number):
            switch action {
            case .number(let value):
                let newNumber = number * 10 + value
                return State.firstInput(Double(newNumber))
            case .operation(let operation):
                return State.operation(number, operation)
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
            case .equal:
                return State.operation(number, operation)
            case .cancel:
                return State.initial
            }
        case .secondInput(let firstNumber, let secondNumber, let operation):
            switch action {
            case .number(let value):
                let newNumber = secondNumber * 10 + value
                return State.secondInput(first: firstNumber, second: newNumber, operation)
            case .operation(let newOperation):
                let newNumber = calculate(firstOperand: firstNumber, secondOperand: secondNumber, operation: operation)
                return State.operation(newNumber, newOperation)
            case .equal:
                let newNumber = calculate(firstOperand: firstNumber, secondOperand: secondNumber, operation: operation)
                return State.finish(newNumber, previousOperand: secondNumber, previousOperation: operation)
            case .cancel:
                return State.initial
            }
        case .finish(let finishValue, previousOperand: let previousOperand, previousOperation: let previousOperation):
            switch action {
            case .number(let value):
                return State.firstInput(value)
            case .operation(let operation):
                return State.operation(finishValue, operation)
            case .equal:
                let newNumber = calculate(firstOperand: finishValue, secondOperand: previousOperand, operation: previousOperation)
                return State.finish(newNumber, previousOperand: previousOperand, previousOperation: previousOperation)
            case .cancel:
                return State.initial
            }
        }
    }
    
    func buttonTapped(with value: String) {
        let action = makeAction(using: value)
        currentState = reduce(state: currentState, action: action)
    }
    
    func makeAction(using value: String) -> Action {
        if "0123456789".contains(value) {
            guard let number = Double(value) else {
                return Action.cancel
            }
            return Action.number(number)
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
        } else if value == "􀆀" {
            return Action.equal
        } else if value == "C" {
            return Action.cancel
        }
        return Action.cancel
    }
    
    func spacingFormat(_ unformatted: String) -> String {
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

        toFormat.reversed().enumerated().forEach { item in
            if item.offset % 3 == 0 && item.offset != 0 {
                formatted = String(item.element) + " " + formatted
            } else {
                formatted = String(item.element) + formatted
            }
        }
        return formatted
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
