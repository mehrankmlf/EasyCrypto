//
//  MockSearchMarket.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
import Combine
@testable import EasyCrypto

class MockSearchMarketUsecase: SearchMarketUsecaseProtocol {
    let mockSearchMarketRepository = MockSearchMarketeRepository()
    func execute(text: String) -> AnyPublisher<EasyCrypto.SearchMarket?, EasyCrypto.APIError> {
        return mockSearchMarketRepository.data(text: text)
    }
}
