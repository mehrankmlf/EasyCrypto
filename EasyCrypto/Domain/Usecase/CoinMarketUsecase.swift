//
//  CoinMarketUsecase.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation
import Combine

protocol CoinDetailUsecaseProtocol : AnyObject {
    func execute(id: String) -> AnyPublisher<CoinUnitDetail?, APIError>
}

final class CoinMarketUsecase: CoinDetailUsecaseProtocol {
    
    private let coinDetailRepository: CoinDetailRepositoryProtocol
    
    init(coinDetailRepository: CoinDetailRepositoryProtocol) {
        self.coinDetailRepository = coinDetailRepository
    }
    
    func execute(id: String) -> AnyPublisher<CoinUnitDetail?, APIError> {
        return self.coinDetailRepository.data(id: id)
    }
}
