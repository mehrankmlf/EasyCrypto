//
//  SearchMarketRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 11/21/1401 AP.
//

import Foundation
import Combine

protocol SearchMarketRepositoryProtocol {
    func data(text: String) -> AnyPublisher<SearchMarket?, APIError>
}

final class SearchMarketRepository {
    
    private let service: SearchMarketDataRemoteProtocol
    
    init(service: SearchMarketDataRemoteProtocol = DIContainer.shared.inject(type: SearchMarketDataRemoteProtocol.self)!) {
        self.service = service
    }
}

extension SearchMarketRepository: SearchMarketRepositoryProtocol {
    func data(text: String) -> AnyPublisher<SearchMarket?, APIError> {
        return self.service.fetch(text: text)
    }
}
