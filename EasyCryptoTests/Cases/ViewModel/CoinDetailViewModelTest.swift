//
//  CoinDetailViewModelTest.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/13/23.
//

import XCTest
import Combine
@testable import EasyCrypto

final class CoinDetailViewModelTest: XCTestCase {
    
    private var viewModelToTest: CoinDetailViewModel!
    private var remote: CoinDetailRemoteMock!
    private var subscriber : Set<AnyCancellable> = []
    
    private var input: CoinDetailViewModel.InputType!
    
    override func setUp()  {
        let usecase = CoinDetailUsecaseMock()
        viewModelToTest = CoinDetailViewModel(coinDetailUsecase: usecase)
        remote = CoinDetailRemoteMock()
        input = CoinDetailViewModel.InputType.onAppear(id: "")
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        viewModelToTest = nil
        input = nil
        remote = nil
        super.tearDown()
    }
    
    func testCoinDetailViewModel_WhenOnAppear_ShouldReturnValid() {
        viewModelToTest.$coinData
            .sinkOnMain { data in
                XCTAssertTrue(data as Any is CoinUnit)
                XCTAssertTrue(data as Any is Decodable)
                XCTAssertEqual(data.id, "bitcoin")
                XCTAssertEqual(data.symbol, "btc")
                XCTAssertEqual(data.name, "Bitcoin")
                XCTAssertEqual(data.description?.en, "Bitcoin is the first successful internet money based on peer-to-peer technology.")
                XCTAssertEqual(data.links?.homepage?.first, "http://www.bitcoin.org")
                XCTAssertEqual(data.marketCapRank, 1)
                XCTAssertEqual(data.coingeckoRank, 1)
            }.store(in: &subscriber)
    }
}

