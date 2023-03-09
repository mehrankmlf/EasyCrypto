//
//  MockSearchMarketeRepository.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
import Combine
@testable import EasyCrypto

class MockSearchMarketeRepository: SearchMarketRepositoryProtocol {
    let mockSearchMarketRemote = MockSearchMarketRemote()
    func data(text: String) -> AnyPublisher<EasyCrypto.SearchMarket?, EasyCrypto.APIError> {
        return mockSearchMarketRemote.fetchedResult
    }
}
