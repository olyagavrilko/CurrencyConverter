//
//  FormatterTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 21.07.2022.
//

import XCTest
@testable import CurrencyConverter

class FormatterTests: XCTestCase {
    
    // MARK: - formattedOutput
    
    func testFormat9() throws {
        let result = try Formatter.formattedOutput("1234")
        XCTAssertEqual(result, "1 234")
    }
    
    func testFormat1() throws {
        let result = try Formatter.formattedOutput("1234,")
        XCTAssertEqual(result, "1 234,")
    }
    
    func testFormat2() throws {
        let result = try Formatter.formattedOutput("1234,50")
        XCTAssertEqual(result, "1 234,50")
    }
    
    func testFormat4() throws {
        let result = try Formatter.formattedOutput("1222333,45")
        XCTAssertEqual(result, "1 222 333,45")
    }
    
    func testFormat6() throws {
        let result = try Formatter.formattedOutput("11222333,45")
        XCTAssertEqual(result, "1,12223e7")
    }
    
    func testFormat8() throws {
        let result = try Formatter.formattedOutput("1234567890")
        XCTAssertEqual(result, "1,23457e9")
    }
    
    func testFormat7() throws {
        let result = try Formatter.formattedOutput("11222333,4")
        XCTAssertEqual(result, "11 222 333,4")
    }
    
    // MARK: - formatToDouble
    
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
    
    // MARK: - formatToString
    
    func testFormatToString1() throws {
        let result = try Formatter.formatToString(5)
        XCTAssertEqual(result, "5")
    }
    
    func testFormatToString2() throws {
        let result = try Formatter.formatToString(100.56)
        XCTAssertEqual(result, "100,56")
    }
    
    func testFormatToString3() throws {
        let result = try Formatter.formatToString(100.567)
        XCTAssertEqual(result, "100,57")
    }
    
    // MARK: - formatToDecimalStyle
    
    func testFormatToDecimalStyle1() throws {
        let result = try Formatter.formatToDecimalStyle("1234")
        XCTAssertEqual(result, "1 234")
    }
    
    func testFormatToDecimalStyle2() throws {
        let result = try Formatter.formatToDecimalStyle("0,")
        XCTAssertEqual(result, "0,")
    }
    
    func testFormatToDecimalStyle3() throws {
        let result = try Formatter.formatToDecimalStyle("0,0")
        XCTAssertEqual(result, "0,0")
    }
    
    func testFormatToDecimalStyle4() throws {
        let result = try Formatter.formatToDecimalStyle("0,00")
        XCTAssertEqual(result, "0,00")
    }
    
    func testFormatToDecimalStyle5() throws {
        let result = try Formatter.formatToDecimalStyle("0,50")
        XCTAssertEqual(result, "0,50")
    }
    
    func testFormatToDecimalStyle6() throws {
        let result = try Formatter.formatToDecimalStyle("0,5")
        XCTAssertEqual(result, "0,5")
    }
    
    // MARK: - formatToScientificStyle
    
    func testFormatToScientificStyle1() throws {
        let result = try Formatter.formatToScientificStyle("1234567890")
        XCTAssertEqual(result, "1,23457e9")
    }
}
