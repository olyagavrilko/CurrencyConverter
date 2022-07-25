//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

enum Operation: String {
    case add = "􀅼"
    case subtract = "􀅽"
    case multiply = "􀅾"
    case divide = "􀅿"
    
    var isPrimary: Bool {
        self == .multiply || self == .divide
    }
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
    case percent
    case equal
    case cancel
}

final class MainViewModel {
    
    weak var view: MainViewController?
    
    var currentState: State = .initial {
        didSet {
            do {
//                view?.update(text: try makeOutputText(using: currentState))
                let original = try makeOutputText(using: currentState)
                let converted = try convert(unconverted: original, exchangeRate: 5)
                view?.update(original: original, converted: converted)
            } catch {
                view?.update(original: AppConsts.error, converted: AppConsts.error)
            }
        }
    }
    
    func makeOutputText(using state: State) throws -> String {
        switch state {
        case .initial:
            return .zero
        case .firstInput(let value):
            return try Formatter.formattedOutput(value)
        case .operation(let value, _):
            return try Formatter.formattedOutput(value)
        case .secondInput(_, let second, _):
            return try Formatter.formattedOutput(second)
        case .secondOperation(_, let second, _, _):
            return try Formatter.formattedOutput(second)
        case .thirdInput(_, _, let third, _, _):
            return try Formatter.formattedOutput(third)
        case .finish(let value, _, _):
            return try Formatter.formattedOutput(value)
        case .error:
            return AppConsts.error
        }
    }
    
    func convert(unconverted: String, exchangeRate: Double) throws -> String {
        let number = try Formatter.formatToDouble(unconverted)
        let result = try Formatter.formatToString(number * exchangeRate)
        return try Formatter.formatToDecimalStyle(result)
    }
    
    func buttonTapped(with value: String) {
        if value.contains("􀄬") {
            switchCurrency()
        }
        let action = makeAction(using: value)
        do {
            currentState = try StateMachine.reduce(state: currentState, action: action)
        } catch {
            currentState = State.error
        }
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
        } else if value == "􀘾" {
            return Action.percent
        }
        return Action.cancel
    }
    
    func switchCurrency() {
        
    }
}
