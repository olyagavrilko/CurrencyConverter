//
//  ValidatorTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 21.07.2022.
//

import XCTest
@testable import CurrencyConverter

class ValidatorTests: XCTestCase {
    
    // MARK: - reachedLimit
    
    func testReachedLimit1() {
        let result = Validator.reachedLimit("12345678")
        XCTAssertEqual(result, false)
    }
    
    func testReachedLimit2() {
        let result = Validator.reachedLimit("123456789")
        XCTAssertEqual(result, true)
    }
    
    func testReachedLimit3() {
        let result = Validator.reachedLimit("0,1")
        XCTAssertEqual(result, false)
    }
    
    func testReachedLimit4() {
        let result = Validator.reachedLimit("0,12")
        XCTAssertEqual(result, true)
    }
    
    func testReachedLimit5() {
        let result = Validator.reachedLimit("1234567,8")
        XCTAssertEqual(result, false)
    }
    
    func testReachedLimit6() {
        let result = Validator.reachedLimit("12345678,9")
        XCTAssertEqual(result, true)
    }
    
    // MARK: - reachedLimitForComma
    
    func testReachedLimitForComma1() {
        let result = Validator.reachedLimitForComma("12345678")
        XCTAssertEqual(result, false)
    }
    
    func testReachedLimitForComma2() {
        let result = Validator.reachedLimitForComma("123456789")
        XCTAssertEqual(result, true)
    }
    
    func testReachedLimitForComma3() {
        let result = Validator.reachedLimitForComma("0,1")
        XCTAssertEqual(result, true)
    }
}
