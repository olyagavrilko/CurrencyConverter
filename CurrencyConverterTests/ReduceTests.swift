//
//  ReduceTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 04.07.2022.
//

import XCTest
@testable import CurrencyConverter

// TODO: Протестировать число, которое не влезает в Double. Должна отображаться "Ошибка"
// TODO: Деление на ноль

class ReduceTests: XCTestCase {
    
// MARK: - InitialState

    func testInitialState1() throws {
        let state = try StateMachine.reduce(state: .initial, action: .number("0"))
        XCTAssertEqual(state, .initial)
    }
    
    func testInitialState2() throws {
        let state = try StateMachine.reduce(state: .initial, action: .number("1"))
        XCTAssertEqual(state, .firstInput("1"))
    }
    
    func testInitialState3() throws {
        let state = try StateMachine.reduce(state: .initial, action: .operation(.add))
        XCTAssertEqual(state, .operation("0", .add))
    }
    
    func testInitialState4() throws {
        let state = try StateMachine.reduce(state: .initial, action: .comma)
        XCTAssertEqual(state, .firstInput("0,"))
    }
    
    func testInitialState5() throws {
        let state = try StateMachine.reduce(state: .initial, action: .equal)
        XCTAssertEqual(state, .initial)
    }
    
    func testInitialState6() throws {
        let state = try StateMachine.reduce(state: .initial, action: .cancel)
        XCTAssertEqual(state, .initial)
    }
    
// MARK: - FirstInputState
    
    func testFirstInputState1() throws {
        let state = try StateMachine.reduce(state: .firstInput("1"), action: .number("2"))
        XCTAssertEqual(state, .firstInput("12"))
    }
    
    // TODO: Повторить на 2 и 3 Input
    func testFirstInputState2() throws {
        let state = try StateMachine.reduce(state: .firstInput("100,000005"), action: .number("2"))
        XCTAssertEqual(state, .firstInput("100,000005"))
    }
    
    func testFirstInputState3() throws {
        let state = try StateMachine.reduce(state: .firstInput("1"), action: .operation(.add))
        XCTAssertEqual(state, .operation("1", .add))
    }
    
    func testFirstInputState4() throws {
        let state = try StateMachine.reduce(state: .firstInput("1"), action: .comma)
        XCTAssertEqual(state, .firstInput("1,"))
    }
    
    func testFirstInputState5() throws {
        let state = try StateMachine.reduce(state: .firstInput("1,5"), action: .comma)
        XCTAssertEqual(state, .firstInput("1,5"))
    }
    
    func testFirstInputState6() throws {
        let state = try StateMachine.reduce(state: .firstInput("1"), action: .equal)
        XCTAssertEqual(state, .firstInput("1"))
    }
    
    func testFirstInputState7() throws {
        let state = try StateMachine.reduce(state: .firstInput("1"), action: .cancel)
        XCTAssertEqual(state, .initial)
    }
    
// MARK: - OperationState
    
    func testOperationState1() throws {
        let state = try StateMachine.reduce(state: .operation("2", .multiply), action: .number("3"))
        XCTAssertEqual(state, .secondInput(first: "2", second: "3", .multiply))
    }
    
    func testOperationState2() throws {
        let state = try StateMachine.reduce(state: .operation("2,", .multiply), action: .number("3"))
        XCTAssertEqual(state, .secondInput(first: "2,", second: "3", .multiply))
    }
    
    func testOperationState3() throws {
        let state = try StateMachine.reduce(state: .operation("2", .multiply), action: .operation(.add))
        XCTAssertEqual(state, .operation("2", .add))
    }
    
    func testOperationState4() throws {
        let state = try StateMachine.reduce(state: .operation("2", .multiply), action: .comma)
        XCTAssertEqual(state, .secondInput(first: "2", second: "0,", .multiply))
    }
    
    func testOperationState5() throws {
        let state = try StateMachine.reduce(state: .operation("5", .multiply), action: .equal)
        XCTAssertEqual(state, .finish("25", previousOperand: "5", previousOperation: .multiply))
    }
    
    func testOperationState6() throws {
        let state = try StateMachine.reduce(state: .operation("2", .multiply), action: .cancel)
        XCTAssertEqual(state, .initial)
    }
    
    
    
// MARK: - SecondInputState
    
    func testSecondInputState1() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "2", .add), action: .number("5"))
        XCTAssertEqual(state, .secondInput(first: "1", second: "25", .add))
    }
    
    func testSecondInputState11() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "222333444", .add), action: .number("5"))
        XCTAssertEqual(state, .secondInput(first: "1", second: "222333444", .add))
    }
    
    func testSecondInputState2() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "2", .add), action: .operation(.multiply))
        XCTAssertEqual(state, .secondOperation(first: "1", second: "2", firstOperation: .add, secondOperation: .multiply))
    }
    
    func testSecondInputState3() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "10", second: "2", .subtract), action: .operation(.divide))
        XCTAssertEqual(state, .secondOperation(first: "10", second: "2", firstOperation: .subtract, secondOperation: .divide))
    }
    
    func testSecondInputState4() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "2", second: "3", .multiply), action: .operation(.add))
        XCTAssertEqual(state, .operation("6", .add))
    }
    
    func testSecondInputState5() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "2", second: "3", .add), action: .operation(.add))
        XCTAssertEqual(state, .operation("5", .add))
    }
    
    func testSecondInputState6() throws {
        XCTAssertThrowsError(
            try StateMachine.reduce(
                state: .secondInput(first: "1", second: "0", .divide),
                action: .operation(.multiply))) { error in
                    guard let error = error as? Calculator.Failure else {
                        return XCTAssert(false)
                    }
                    XCTAssertEqual(error, .divideOnZero)
                }
    }
    
    func testSecondInputState7() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "2", .add), action: .comma)
        XCTAssertEqual(state, .secondInput(first: "1", second: "2,", .add))
    }
    
    func testSecondInputState12() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "2,", .add), action: .comma)
        XCTAssertEqual(state, .secondInput(first: "1", second: "2,", .add))
    }
    
    func testSecondInputState8() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "2", .add), action: .equal)
        XCTAssertEqual(state, .finish("3", previousOperand: "2", previousOperation: .add))
    }
    
    func testSecondInputState9() {
        XCTAssertThrowsError(
            try StateMachine.reduce(
                state: .secondInput(first: "1", second: "0", .divide),
                action: .equal)) { error in
                    guard let error = error as? Calculator.Failure else {
                        return XCTAssert(false)
                    }
                    XCTAssertEqual(error, .divideOnZero)
                }
    }
    
    func testSecondInputState10() throws {
        let state = try StateMachine.reduce(state: .secondInput(first: "1", second: "2", .add), action: .cancel)
        XCTAssertEqual(state, .initial)
    }
    
// MARK: - SecondOperationState
    
    func testSecondOperationState1() throws {
        let state = try StateMachine.reduce(
            state: .secondOperation(
                first: "3",
                second: "2",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .number("4"))
        
        XCTAssertEqual(state, .thirdInput(
            first: "3",
            second: "2",
            third: "4",
            firstOperation: .add,
            secondOperation: .multiply))
    }
    
    func testSecondOperationState2() throws {
        let state = try StateMachine.reduce(
            state: .secondOperation(
                first: "3",
                second: "2",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .operation(.divide))
        
        XCTAssertEqual(state, .secondOperation(
            first: "3",
            second: "2",
            firstOperation: .add,
            secondOperation: .divide))
    }
    
    func testSecondOperationState3() throws {
        let state = try StateMachine.reduce(
            state: .secondOperation(
                first: "3",
                second: "2",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .comma)
        
        XCTAssertEqual(state, .thirdInput(
            first: "3",
            second: "2",
            third: "0,",
            firstOperation: .add,
            secondOperation: .multiply))
    }
    
    func testSecondOperationState4() throws {
        let state = try StateMachine.reduce(
            state: .secondOperation(
                first: "3",
                second: "2",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .equal)
        
        XCTAssertEqual(state, .finish("7", previousOperand: "2", previousOperation: .multiply))
    }
    
    func testSecondOperationState5() throws {
        let state = try StateMachine.reduce(
            state: .secondOperation(
                first: "3",
                second: "2",
                firstOperation: .multiply,
                secondOperation: .add),
            action: .equal)
        
        XCTAssertEqual(state, .finish("12", previousOperand: "6", previousOperation: .add))
    }
    
    func testSecondOperationState6() throws {
        let state = try StateMachine.reduce(
            state: .secondOperation(
                first: "3",
                second: "2",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .cancel)
        
        XCTAssertEqual(state, .initial)
    }
    
// MARK: - ThirdInputState
    
    func testThirdInputState1() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "1",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .number("3"))
        
        XCTAssertEqual(state, .thirdInput(
            first: "2",
            second: "3",
            third: "13",
            firstOperation: .add,
            secondOperation: .multiply))
    }
    
    func testThirdInputState9() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "111222333",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .number("4"))
        
        XCTAssertEqual(state, .thirdInput(
            first: "2",
            second: "3",
            third: "111222333",
            firstOperation: .add,
            secondOperation: .multiply))
    }
    
    func testThirdInputState2() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "5",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .operation(.divide))
        
        XCTAssertEqual(state, .secondOperation(
            first: "2",
            second: "15",
            firstOperation: .add,
            secondOperation: .divide))
    }
    
    func testThirdInputState3() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "5",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .operation(.subtract))
        
        XCTAssertEqual(state, .operation("17", .subtract))
    }
    
    func testThirdInputState4() throws {
        XCTAssertThrowsError(
            try StateMachine.reduce(
                state: .thirdInput(
                    first: "2",
                    second: "3",
                    third: "0",
                    firstOperation: .add,
                    secondOperation: .divide),
                action: .operation(.subtract))
        ) { error in
            guard let error = error as? Calculator.Failure else {
                return XCTAssert(false)
            }
            XCTAssertEqual(error, .divideOnZero)
        }
    }
    
    func testThirdInputState5() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "5",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .comma)
        
        XCTAssertEqual(state, .thirdInput(
            first: "2",
            second: "3",
            third: "5,",
            firstOperation: .add,
            secondOperation: .multiply))
    }
    
    func testThirdInputState10() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "5,",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .comma)
        
        XCTAssertEqual(state, .thirdInput(
            first: "2",
            second: "3",
            third: "5,",
            firstOperation: .add,
            secondOperation: .multiply))
    }
    
    func testThirdInputState6() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "5",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .equal)
        
        XCTAssertEqual(state, .finish("17", previousOperand: "5", previousOperation: .multiply))
    }
    
    func testThirdInputState7() throws {
        XCTAssertThrowsError(
            try StateMachine.reduce(
                state: .thirdInput(
                    first: "2",
                    second: "3",
                    third: "0",
                    firstOperation: .add,
                    secondOperation: .divide),
                action: .equal)
        ) { error in
            guard let error = error as? Calculator.Failure else {
                return XCTAssert(false)
            }
            XCTAssertEqual(error, .divideOnZero)
        }
    }
    
    func testThirdInputState8() throws {
        let state = try StateMachine.reduce(
            state: .thirdInput(
                first: "2",
                second: "3",
                third: "5",
                firstOperation: .add,
                secondOperation: .multiply),
            action: .cancel)
        
        XCTAssertEqual(state, .initial)
    }
    
// MARK: - FinishState
    
    func testFinishState1() throws {
        let state = try StateMachine.reduce(
            state: .finish("5", previousOperand: "2", previousOperation: .add),
            action: .number("3"))
        
        XCTAssertEqual(state, .firstInput("3"))
    }
    
    func testFinishState2() throws {
        let state = try StateMachine.reduce(
            state: .finish("5", previousOperand: "2", previousOperation: .add),
            action: .operation(.subtract))
        
        XCTAssertEqual(state, .operation("5", .subtract))
    }
    
    func testFinishState3() throws {
        let state = try StateMachine.reduce(
            state: .finish("5", previousOperand: "2", previousOperation: .add),
            action: .comma)
        
        XCTAssertEqual(state, .firstInput("0,"))
    }
    
    func testFinishState4() throws {
        let state = try StateMachine.reduce(
            state: .finish("5", previousOperand: "2", previousOperation: .add),
            action: .equal)
        
        XCTAssertEqual(state, .finish("7", previousOperand: "2", previousOperation: .add))
    }
    
    func testFinishState5() throws {
        let state = try StateMachine.reduce(
            state: .finish("5", previousOperand: "2", previousOperation: .add),
            action: .cancel)
        
        XCTAssertEqual(state, .initial)
    }
    
// MARK: - ErrorState
    
     // TODO: Работает не так, как на телефоне
    func testErrorState1() throws {
        let state = try StateMachine.reduce(state: .error, action: .number("5"))
        
        XCTAssertEqual(state, .firstInput("5"))
    }
    
    func testErrorState2() throws {
        let state = try StateMachine.reduce(state: .error, action: .operation(.add))
        
        XCTAssertEqual(state, .error)
    }
    
    func testErrorState3() throws {
        let state = try StateMachine.reduce(state: .error, action: .comma)
        
        XCTAssertEqual(state, .firstInput("0,"))
    }
    
    func testErrorState4() throws {
        let state = try StateMachine.reduce(state: .error, action: .equal)
        
        XCTAssertEqual(state, .error)
    }
    
    func testErrorState5() throws {
        let state = try StateMachine.reduce(state: .error, action: .cancel)
        
        XCTAssertEqual(state, .initial)
    }
}

//enum State: Equatable {
//    case initial
//    case inputComma(String)
//    case firstInput(String)
//    case operation(String, Operation)
//    case secondInput(first: String, second: String, Operation)
//    case finish(String, previousOperand: String, previousOperation: Operation)
//}
//
//enum Action {
//    case number(String)
//    case operation(Operation)
//    case comma
//    case equal
////        case percent
//    case cancel
//}
