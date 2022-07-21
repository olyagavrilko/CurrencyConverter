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
                view?.update(text: try makeText(using: currentState))
            } catch {
                view?.update(text: "Ошибка")
            }
        }
    }
    
    // TODO: Написать все тесты со значениями больше 3-х разрядов. Тогда будут добавляться пробелы. Это будет значить, что мы нигде не забыли поставить функцию format
    func makeText(using state: State) throws -> String {
        switch state {
        case .initial:
            return "0"
        case .firstInput(let value):
            return try Formatter.format(value)
        case .operation(let value, _):
            return try Formatter.format(value)
        case .secondInput(_, let second, _):
            return try Formatter.format(second)
        case .secondOperation(_, let second, _, _):
            return try Formatter.format(second)
        case .thirdInput(_, _, let third, _, _):
            return try Formatter.format(third)
        case .finish(let value, _, _):
            return try Formatter.format(value)
        case .error:
            return "Ошибка"
        }
    }
    
    func buttonTapped(with value: String) {
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
        }
        return Action.cancel
    }
}
