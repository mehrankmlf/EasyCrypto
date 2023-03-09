//
//  MarketPriceRequestTest.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import XCTest
@testable import EasyCrypto

final class MarketPriceRequestTest: XCTestCase {

    var sut: NetworkTarget!

    override func setUp() {
        sut = DummyTarget()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testNetworkTarget_WhenBaseURl_ShouldReturnString() {
        XCTAssertTrue(sut.baseURL.desc as Any is URL)
    }
    
    func testNetworkTarget_WhenBaseURl_ShouldReturnURL() {
        XCTAssertEqual(sut.baseURL.desc, URL("https://api.coingecko.com/api"))
    }
    
    func testNetworkTarget_WhenVersion_ShouldReturnString() {
        XCTAssertTrue(sut.version.desc as Any is String)
    }
    
    func testNetworkTarget_WhenVersion_ShouldReturnVersion() {
        XCTAssertEqual(sut.version.desc, "/v1")
    }
    
    func testNetworkTarget_WhenPath_ShouldBeRequestType() {
        XCTAssertTrue(sut.path as Any is String)
    }
    
    func testNetworkTarget_WhenPath_ShouldReturnPath() {
        XCTAssertEqual(sut.path, "test/test")
    }

    func testNetworkTarget_WhenMethod_ShouldReturnType() {
        XCTAssertEqual(sut.methodType, .get)
    }
    
    func testNetworkTarget_QueryParam_ShouldReturnType() {
        XCTAssertEqual(sut.queryParamsEncoding, .default)
    }
}
