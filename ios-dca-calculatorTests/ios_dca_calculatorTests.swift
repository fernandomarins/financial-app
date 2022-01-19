//
//  ios_dca_calculatorTests.swift
//  ios-dca-calculatorTests
//
//  Created by Fernando Marins on 18/01/22.
//

import XCTest
@testable import ios_dca_calculator

class ios_dca_calculatorTests: XCTestCase {
    
    var sut: DCAServices!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAServices()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
        
    }

    
}
