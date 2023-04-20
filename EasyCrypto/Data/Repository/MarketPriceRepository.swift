//
//  MarketPriceRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol MarketPricRepositoryProrocol {
    func data(vs_currency: String,
              order: String,
              per_page: Int,
              page: Int,
              sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError>
}

final class MarketPriceRepository {

    private let service: MarketPricRemoteProtocol

    init(service: MarketPricRemoteProtocol = DIContainer.shared.inject(type: MarketPricRemoteProtocol.self)!) {
        self.service = service
    }
}

extension MarketPriceRepository: MarketPricRepositoryProrocol {
    func data(vs_currency: String,
              order: String,
              per_page: Int,
              page: Int,
              sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError> {
        return self.service.fetch(vs_currency: vs_currency,
                                  order: order,
                                  per_page: per_page,
                                  page: page,
                                  sparkline: sparkline)
    }
}
