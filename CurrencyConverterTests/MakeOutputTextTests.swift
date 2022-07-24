//
//  MakeOutputTextTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 19.07.2022.
//

import XCTest
@testable import CurrencyConverter

final class MakeOutputTextTests: XCTestCase {
    
    let viewModel = MainViewModel()
    
    func testOutputText1() throws {
        let result = try viewModel.makeOutputText(using: .initial)
        XCTAssertEqual(result, .zero)
    }
    
    func testOutputText2() throws {
        let result = try viewModel.makeOutputText(using: .firstInput("1234"))
        XCTAssertEqual(result, "1 234")
    }
    
    func testOutputText3() throws {
        let result = try viewModel.makeOutputText(using: .operation("1234", .add))
        XCTAssertEqual(result, "1 234")
    }
    
    func testOutputText4() throws {
        let result = try viewModel.makeOutputText(using: .secondInput(first: "1", second: "1234", .add))
        XCTAssertEqual(result, "1 234")
    }
    
    func testOutputText5() throws {
        let result = try viewModel.makeOutputText(using: .secondOperation(first: "1", second: "1234", firstOperation: .add, secondOperation: .multiply))
        XCTAssertEqual(result, "1 234")
    }
    
    func testOutputText6() throws {
        let result = try viewModel.makeOutputText(using: .thirdInput(first: "1", second: "1", third: "1234", firstOperation: .add, secondOperation: .multiply))
        XCTAssertEqual(result, "1 234")
    }
    
    func testOutputText7() throws {
        let result = try viewModel.makeOutputText(using: .finish("1234", previousOperand: "1", previousOperation: .add))
        XCTAssertEqual(result, "1 234")
    }
    
    func testOutputText8() throws {
        let result = try viewModel.makeOutputText(using: .error)
        XCTAssertEqual(result, AppConsts.error)
    }
}
