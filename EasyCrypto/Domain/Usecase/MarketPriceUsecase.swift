//
//  MarketPriceUsecase.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol MarketPriceUsecaseProtocol : AnyObject {
    func execute(vs_currency: String,
                 order: String,
                 per_page: Int,
                 page: Int,
                 sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError>
}

final class MarketPriceUsecase: MarketPriceUsecaseProtocol {
    
    private let marketPriceRepository: MarketPricRepositoryProrocol
    
    init(marketPriceRepository: MarketPricRepositoryProrocol = DIContainer.shared.inject(type: MarketPricRepositoryProrocol.self)!) {
        self.marketPriceRepository = marketPriceRepository
    }
    
    func execute(vs_currency: String,
                 order: String,
                 per_page: Int,
                 page: Int,
                 sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError> {
        return self.marketPriceRepository.data(vs_currency: vs_currency,
                                        order: order,
                                        per_page: per_page,
                                        page: page,
                                        sparkline: sparkline)
    }
}
