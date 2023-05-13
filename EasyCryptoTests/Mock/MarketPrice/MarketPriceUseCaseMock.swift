//
//  MockMarketPriceUserCase.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
import Combine
@testable import EasyCrypto

final class MarketPriceUseCaseMock: MarketPriceUsecaseProtocol {
    let mockMarketPriceRepisitory = MarketPriceRepositoryMock()
    func execute(vs_currency: String, order: String, per_page: Int, page: Int, sparkline: Bool) -> AnyPublisher<[EasyCrypto.MarketsPrice]?, EasyCrypto.APIError> {
        return mockMarketPriceRepisitory.data(vs_currency: vs_currency, order: order, per_page: per_page, page: page, sparkline: sparkline)
    }
}
