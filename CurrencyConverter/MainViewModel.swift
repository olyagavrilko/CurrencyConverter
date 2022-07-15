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
    case equal
//        case percent
    case cancel
}

final class MainViewModel {
    
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
}
