//
//  StateToTextTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 06.07.2022.
//

import XCTest
@testable import CurrencyConverter

final class StateToTextTests: XCTestCase {
    
    let viewModel = MainViewModel()
    
    func testInitialState() throws {
        let text = try viewModel.makeOutput(using: .initial)
        XCTAssertEqual(text, "0")
    }
    
//    func testFirstInputState() {
//        let text = viewModel.makeText(using: .firstInput(56.47))
//        XCTAssertEqual(text, "56,47")
//    }
//    
//    func testOperationState() {
//        let text = viewModel.makeText(using: .operation(50.5, .add))
//        XCTAssertEqual(text, "50,5")
//    }
//    
//    func testSecondInput() {
//        let text = viewModel.makeText(using: .secondInput(first: 7, second: 3, .divide))
//        XCTAssertEqual(text, "3")
//    }
//    
//    func testFinishState() {
//        let text = viewModel.makeText(using: .finish(15, previousOperand: 7, previousOperation: .multiply))
//        XCTAssertEqual(text, "15")
//    }
}
