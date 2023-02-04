//
//  MarketPriceUsecase.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol MarketPriceUsecaseInterface : AnyObject {
    func execute(vs_currency: String,
                 order: String,
                 per_page: Int,
                 page: Int,
                 sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError>
}

final class MarketPriceUsecase: MarketPriceUsecaseInterface {
    
    private let marketPriceRepository: MarketPriceRepository
    
    init(marketPriceRepository: MarketPriceRepository) {
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
