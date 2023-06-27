//
//  SearchMarket.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/17/1401 AP.
//

import XCTest
@testable import EasyCrypto

final class SearchMarketTest: XCTestCase {

    var sut: Coin!

    override func setUp() {
        // Arrange
        sut = Coin.mock
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

    func testSafeImageURL_ShouldReturnValidType() {
        XCTAssertTrue(sut.safeImageURL() as Any is String)
    }
    
    func testSafeImageURL_ShouldReturnString() {
        XCTAssertEqual(sut.safeImageURL(), "https://assets.coingecko.com/coins/images/479/large/firocoingecko.png")
    }
    
    func testCoin_ShouldReturnValidType() {
        XCTAssertTrue(sut.id as Any is String)
        XCTAssertTrue(sut.id == "zcoin")
        XCTAssertTrue(sut.name as Any is String)
        XCTAssertTrue(sut.name == "Firo")
    }
}
