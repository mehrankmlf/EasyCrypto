//
//  CoinDetailUsecaseMock.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/13/23.
//

import Foundation
import Combine
@testable import EasyCrypto

final class CoinDetailUsecaseMock: CoinDetailUsecaseProtocol {
    let repository = CoinDetailRepositoryMock()
    func execute(id: String) -> AnyPublisher<EasyCrypto.CoinUnit?, EasyCrypto.APIError> {
        return repository.data(id: "")
    }
}
