//
//  MockMarketPriceService.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
import Combine
@testable import EasyCrypto

final class MarketPriceRemoteMock: MarketPricRemoteProtocol {
    var fetchedResult: AnyPublisher <[EasyCrypto.MarketsPrice]?, APIError>!
    func fetch(vs_currency: String, order: String, per_page: Int, page: Int, sparkline: Bool) -> AnyPublisher<[EasyCrypto.MarketsPrice]?, EasyCrypto.APIError> {
        return fetchedResult
    }
}
