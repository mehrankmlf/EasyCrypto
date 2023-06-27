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
    private var marketPrice: MarketPriceRemoteMock!
    private var searchMarket: MockSearchMarketRemote!
    private var subscriber : Set<AnyCancellable> = []
    
    private var input: MainViewModel.InputType!
    
    override func setUp()  {
        viewModelToTest = MainViewModel()
        marketPrice = MarketPriceRemoteMock()
        searchMarket = MockSearchMarketRemote()
        input = MainViewModel.InputType.onAppear
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        viewModelToTest = nil
        marketPrice = nil
        searchMarket = nil
        input = nil
        super.tearDown()
    }
    
    func testMainViewModel_WhenMarketServiceCalled_ShouldReturnResponse() {
        //Arrange
        let data = MarketsPrice.mockArray

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        marketPrice.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMarketData()

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_WhenMarketServiceCalled_ShouldReturnNil() {
        //Arrange
        let data = [MarketsPrice]()

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        marketPrice.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getMarketData()

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_MarketSearchCalled_ShouldReturnResponse() {
        //Arrange
        let data = SearchMarket.mock

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        searchMarket.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.searchMarketData(text: "")

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_MarketSearchCalled_ShouldReturnNil() {
        //Arrange
        let data = SearchMarket(coins: nil)

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadinState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        searchMarket.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.searchMarketData(text: "")

        wait(for: [expectation], timeout: 1)
    }
    
    func testMainViewModel_ResultSortASC_ShouldReturnSorted() {
        //Arrange
        let data = MarketsPrice.mockArray
        
        viewModelToTest.marketData = data
        // Act
        viewModelToTest.sortList(type: .rankASC)
        
        let sorted = viewModelToTest.marketData
        // Assert
        XCTAssertEqual(sorted, MarketsPrice.mockArray)
    }
    
    func testMainViewModel_ResultSortDSC_ShouldReturnSorted() {
        //Arrange
        let data = MarketsPrice.mockArray
        
        viewModelToTest.marketData = data
        // Act
        viewModelToTest.sortList(type: .rankDSC)
        
        let sorted = viewModelToTest.marketData
        // Assert
        XCTAssertEqual(sorted, MarketsPrice.mockArray.reversed())
    }

}
