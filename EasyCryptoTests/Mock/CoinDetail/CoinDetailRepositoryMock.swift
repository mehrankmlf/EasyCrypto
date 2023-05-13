//
//  CoinDetailRepositoryMock.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/13/23.
//

import Foundation
import Combine
@testable import EasyCrypto

final class CoinDetailRepositoryMock: CoinDetailRepositoryProtocol {
    let coinDetailRemoteMock = CoinDetailRemoteMock()
    func data(id: String) -> AnyPublisher<EasyCrypto.CoinUnit?, EasyCrypto.APIError> {
        return coinDetailRemoteMock.fetch(id: "")
    }
}
