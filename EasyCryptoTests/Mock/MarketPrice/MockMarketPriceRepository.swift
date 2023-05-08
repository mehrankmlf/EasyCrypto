//
//  MockMarketPriceRemote.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
import Combine
@testable import EasyCrypto

class MockMarketPriceRepository: MarketPricRepositoryProrocol {
    let mockMarketPriceService = MockMarketPriceRemote()
    func data(vs_currency: String, order: String, per_page: Int, page: Int, sparkline: Bool) -> AnyPublisher<[EasyCrypto.MarketsPrice]?, EasyCrypto.APIError> {
         return mockMarketPriceService.fetchedResult
    }
}
