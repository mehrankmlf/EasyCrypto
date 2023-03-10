//
//  MainViewModelTest.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/17/1401 AP.
//

import XCTest
import Combine
@testable import EasyCrypto

final class MainViewModelTest: XCTestCase {

    private var viewModelToTest: MainViewModel!
    private var marketPrice: MockMarketPriceRemote!
    private var searchMarket: MockSearchMarketRemote!
    private var subscriber : Set<AnyCancellable> = []
    
    override func setUp()  {
        viewModelToTest = MainViewModel()
        marketPrice = MockMarketPriceRemote()
        searchMarket = MockSearchMarketRemote()
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        viewModelToTest = nil
        marketPrice = nil
        searchMarket = nil
        super.tearDown()
    }
    
    func testMainViewModel_WhenMarketServiceCalled_ShouldReturnResponse() {
        let data = MarketsPrice.mockArray

        let expectation = XCTestExpectation(description: "State is set to Token")

        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)

        marketPrice.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMarketData()

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenMarketServiceCalled_ShouldReturnNil() {
        let data = [MarketsPrice]()

        let expectation = XCTestExpectation(description: "State is set to Token")

        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)

        marketPrice.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMarketData()

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_MarketSearchCalled_ShouldReturnResponse() {
        let data = SearchMarket.mock

        let expectation = XCTestExpectation(description: "State is set to Token")

        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)

        searchMarket.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.searchMarketData(text: "")

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_MarketSearchCalled_ShouldReturnNil() {
        let data = SearchMarket(coins: nil)

        let expectation = XCTestExpectation(description: "State is set to Token")

        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)

        searchMarket.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.searchMarketData(text: "")

        wait(for: [expectation], timeout: 1)
    }
}
