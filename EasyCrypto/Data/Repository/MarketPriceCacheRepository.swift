//
//  MarketPriceCacheRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 1/5/1402 AP.
//

import Foundation
import CoreData
import Combine

protocol MarketPriceCacheRepositoryProtocol {
    func save(name: String,
              price: Double,
              price24Hours: Double,
              priceChangePercentage24H: Double,
              totalSupply: Double,
              marketCapRank: Int,
              marketCap: Int,
              low24H: Double,
              high24H: Double,
              circulatingSupply: Double) throws
    func fetch() throws -> [CoinENT]?
}

final class MarketPriceCacheRepository: MarketPriceCacheRepositoryProtocol {
    
    let coreDataManager: CoreDataManagerProtocol
    let subscriber = Cancelable()
    
    init(coreDataManager: CoreDataManagerProtocol = DIContainer.shared.inject(type: CoreDataManagerProtocol.self)!) {
        self.coreDataManager = coreDataManager
    }
    
    func save(name: String,
              price: Double,
              price24Hours: Double,
              priceChangePercentage24H: Double,
              totalSupply: Double,
              marketCapRank: Int,
              marketCap: Int,
              low24H: Double,
              high24H: Double,
              circulatingSupply: Double) {
        let action: Action = {
            let coin: CoinENT = self.coreDataManager.createEntity()
            coin.name = name
            coin.price = price
            coin.priceChange24H = price
            coin.priceChangePercentage24H = priceChangePercentage24H
            coin.totalSupply = totalSupply
            coin.marketCapRank = Int16(marketCapRank)
            coin.marketCap = Int16(marketCap)
            coin.low24H = low24H
            coin.high24H = high24H
        }
        self.coreDataManager
            .publisher(save: action)
            .sinkOnMain { completion in
                switch completion {
                case .failure(let error):
                    log("Saving Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { success in
                if success {
                    log("Saving Done)")
                }
            }.store(in: subscriber)
    }
    
    func fetch() throws -> [CoinENT]? {
        let request = NSFetchRequest<CoinENT>(entityName: CoinENT.entityName)
        var outPut: [CoinENT] = []
        self.coreDataManager
            .publicher(fetch: request)
            .sinkOnMain { completion in
                switch completion {
                case .failure(let error):
                    log("Saving Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { value in
                outPut.append(contentsOf: value)
            }.store(in: subscriber)
        return outPut
    }
}

enum AverageCalculationError: Error {
    case noProducts
    case productWithNoPrice
}


