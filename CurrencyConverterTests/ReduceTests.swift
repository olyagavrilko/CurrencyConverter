//
//  ReduceTests.swift
//  CurrencyConverterTests
//
//  Created by Olya Ganeva on 04.07.2022.
//

import XCTest
@testable import CurrencyConverter

class ReduceTests: XCTestCase {
    
    let viewModel = MainViewModel()

    func testExample() throws {
        let state = viewModel.reduce(
            state: .initial,
            action: .number(0))
        XCTAssertEqual(state, .firstInput(0))
    }
}
