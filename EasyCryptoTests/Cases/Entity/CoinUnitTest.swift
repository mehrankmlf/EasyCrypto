//
//  CoinUnitTest.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/17/1401 AP.
//

import XCTest
@testable import EasyCrypto

final class CoinUnitTest: XCTestCase {

    var sut: CoinUnit!

    override func setUp() {
        // Arrange
        sut = CoinUnit.mock
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testConformTo_Decodable() {
        XCTAssertTrue(sut as Any is Decodable)
    }
    
    func testConformTo_Equtable() {
        XCTAssertEqual(sut, sut)
    }
 
    func testValidId() {
        XCTAssertTrue(sut.id as Any is String)
    }
}
