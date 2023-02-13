//
//  CoinDetailRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//
import Foundation
import Combine

protocol SearchMarketRepositoryProtocol {
    func data(text: String) -> AnyPublisher<SearchMarket?, APIError>
}

final class SearchMarketRepository: SearchMarketRepositoryProtocol {
    
    private let service: SearchMarketDataRemoteProtocol
    
    init(service: SearchMarketDataRemoteProtocol) {
        self.service = service
    }
    
    func data(text: String) -> AnyPublisher<SearchMarket?, APIError> {
        return self.service.fetch(text: text)
    }
}
