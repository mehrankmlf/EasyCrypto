//
//  CoinDetailRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//
import Foundation
import Combine

protocol CoinDetailRepositoryProtocol {
    func data(id: String) -> AnyPublisher<CoinUnitDetail?, APIError>
}

final class CoinDetailRepository: CoinDetailRepositoryProtocol {
    
    private let service: CoinDetailRemoteProtocol
    
    init(service: CoinDetailRemoteProtocol) {
        self.service = service
    }
    
    func data(id: String) -> AnyPublisher<CoinUnitDetail?, APIError> {
        return self.service.fetch(id: id)
    }
}
