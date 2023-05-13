//
//  MockCoinDetailRemote.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/13/23.
//

import Foundation
import Combine
@testable import EasyCrypto

final class CoinDetailRemoteMock: CoinDetailRemoteProtocol {
    var fetchedResult: AnyPublisher <CoinUnit?, APIError>!
    func fetch(id: String) -> AnyPublisher<EasyCrypto.CoinUnit?, EasyCrypto.APIError> {
        Just(CoinUnit.mock)
            .setFailureType(to: EasyCrypto.APIError.self)
            .eraseToAnyPublisher()
    }
}
