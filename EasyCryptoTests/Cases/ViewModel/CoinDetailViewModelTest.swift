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
    private var subscriber : Set<AnyCancellable> = []

    override func setUp()  {
        let usecase = CoinDetailUsecaseMock()
        viewModelToTest = CoinDetailViewModel(coinDetailUsecase: usecase)
    }
    
    override func tearDown() {
        viewModelToTest = nil
        super.tearDown()
    }
    
    
}
