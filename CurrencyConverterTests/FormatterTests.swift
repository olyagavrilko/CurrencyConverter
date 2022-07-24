//
//  FormatterTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 21.07.2022.
//

import XCTest
@testable import CurrencyConverter

class FormatterTests: XCTestCase {
    
    func testFormatToDouble1() throws {
        let result = try Formatter.formatToDouble("555,5")
        XCTAssertEqual(result, 555.5)
    }
    
    func testFormatToDouble2() throws {
        let result = try Formatter.formatToDouble("555,")
        XCTAssertEqual(result, 555)
    }
    
    func testFormatToDouble3() throws {
        let result = try Formatter.formatToDouble("555")
        XCTAssertEqual(result, 555)
    }
    
    func testFormatToString1() throws {
        let result = try Formatter.formatToString(5)
        XCTAssertEqual(result, "5")
    }
    
    func testFormatToString2() throws {
        let result = try Formatter.formatToString(100.56)
        XCTAssertEqual(result, "100,56")
    }
    
    func testFormat1() throws {
        let result = try Formatter.format("111222333,567")
        XCTAssertEqual(result, "1,11222e8")
    }
    
    func testFormat2() throws {
        let result = try Formatter.format("1112223,567")
        XCTAssertEqual(result, "1 112 223,57")
    }
    
    func testFormat3() throws {
        let result = try Formatter.format("1112223")
        XCTAssertEqual(result, "1 112 223")
    }
    
    func testFormat4() throws {
        let result = try Formatter.format("111222,378")
        XCTAssertEqual(result, "111 222,38")
    }
    
    func testFormat5() throws {
        let result = try Formatter.format("111222333444555")
        XCTAssertEqual(result, "1,11222e14")
    }
}
