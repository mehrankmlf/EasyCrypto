//
//  CoinDetailRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//
import Foundation
import Combine

protocol CoinDetailRepositoryProtocol {
    func data(id: String) -> AnyPublisher<CoinUnit?, APIError>
}

final class CoinDetailRepository {

    private let service: CoinDetailRemoteProtocol

    init(service: CoinDetailRemoteProtocol = DIContainer.shared.inject(type: CoinDetailRemoteProtocol.self)!) {
        self.service = service
    }
}

extension CoinDetailRepository: CoinDetailRepositoryProtocol {
    func data(id: String) -> AnyPublisher<CoinUnit?, APIError> {
        return self.service.fetch(id: id)
    }
}
