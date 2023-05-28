//
//  MarketsPriceTest.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/17/1401 AP.
//

import XCTest
@testable import EasyCrypto

final class MarketsPriceTest: XCTestCase {
    
    var sut: MarketsPrice!

    override func setUp() {
        sut = MarketsPrice.mock
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
        XCTAssertEqual(sut.safeImageURL(), "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
    }
    
    func testMarketPrice_ShouldReturnValidType() {
        XCTAssertTrue(sut.id as Any is String)
        XCTAssertTrue(sut.id == "test1")
        XCTAssertTrue(sut.name as Any is String)
        XCTAssertTrue(sut.name == "test1")
        XCTAssertTrue(sut.symbol as Any is String)
        XCTAssertTrue(sut.symbol == "test1")
        XCTAssertTrue(sut.image as Any is String)
        XCTAssertTrue(sut.image == "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
    }
}
