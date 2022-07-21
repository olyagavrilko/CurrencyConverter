//
//  CalculatorTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 21.07.2022.
//

import XCTest
@testable import CurrencyConverter

class CalculatorTests: XCTestCase {
    
    func testAdd() throws {
        let result = try Calculator.calculate(first: 5, second: 4, operation: .add)
        XCTAssertEqual(result, 9)
    }
    
    func testSubtract() throws {
        let result = try Calculator.calculate(first: 5, second: 4, operation: .subtract)
        XCTAssertEqual(result, 1)
    }
    
    func testMultiply() throws {
        let result = try Calculator.calculate(first: 5, second: 4, operation: .multiply)
        XCTAssertEqual(result, 20)
    }
    
    func testDivide() throws {
        let result = try Calculator.calculate(first: 10, second: 2, operation: .divide)
        XCTAssertEqual(result, 5)
    }
    
    func testDivideOnZero() throws {
        XCTAssertThrowsError(try Calculator.calculate(first: 5, second: 0, operation: .divide)) { error in
            guard let error = error as? Calculator.Failure else {
                return XCTAssert(false)
            }
            XCTAssertEqual(error, .divideOnZero)
        }
    }
    
    func testOverflow() throws {
        XCTAssertThrowsError(try Calculator.calculate(first: 1.7976931348623157e+308, second: 10, operation: .multiply)) { error in
            guard let error = error as? Calculator.Failure else {
                return XCTAssert(false)
            }
            XCTAssertEqual(error, .overflow)
        }
    }
}
