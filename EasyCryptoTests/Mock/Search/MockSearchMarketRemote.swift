//
//  MockSearchMarketService.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
import Combine
@testable import EasyCrypto

class MockSearchMarketRemote: SearchMarketDataRemoteProtocol {
    var fetchedResult : AnyPublisher <EasyCrypto.SearchMarket?, APIError>!
    func fetch(text: String) -> AnyPublisher<EasyCrypto.SearchMarket?, EasyCrypto.APIError> {
        return fetchedResult
    }
}
