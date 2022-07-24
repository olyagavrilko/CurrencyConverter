//
//  ValidatorTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 21.07.2022.
//

import XCTest
@testable import CurrencyConverter

//class ValidatorTests: XCTestCase {
//    
//    func test1() {
//        let result = Validator.validateForInput(number: "111", digit: "2")
//        XCTAssertEqual(result, "1112")
//    }
//    
//    func test() {
//        let result = Validator.validateForInput(number: "111,", digit: "2")
//        XCTAssertEqual(result, "111,2")
//    }
//    
//    func testOverDigit() {
//        let result = Validator.validateForInput(number: "111222333", digit: "4")
//        XCTAssertEqual(result, "111222333")
//    }
//    
//    func testOverDigitWithComma() {
//        let result = Validator.validateForInput(number: "111,222333", digit: "4")
//        XCTAssertEqual(result, "111,222333")
//    }
//    
//    func test3() {
//        let result = Validator.validateForComma(number: "12,6")
//        XCTAssertEqual(result, "12,6")
//    }
//    
//    func test4() {
//        let result = Validator.validateForComma(number: "126")
//        XCTAssertEqual(result, "126,")
//    }
//    
//    func test5() {
//        let result = Validator.validateForComma(number: "111222333")
//        XCTAssertEqual(result, "111222333")
//    }
//}
