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
    func save(_ data: [MarketsPrice]) throws
    func fetch() throws -> [CoinENT]?
    func delete() throws
}

final class MarketPriceCacheRepository: MarketPriceCacheRepositoryProtocol {
    
    let coreDataManager: CoreDataManagerProtocol
    let subscriber = Cancelable()
    
    init(coreDataManager: CoreDataManagerProtocol = DIContainer.shared.inject(type: CoreDataManagerProtocol.self)!) {
        self.coreDataManager = coreDataManager
    }
    
    func save(_ data: [MarketsPrice]) {

        let action: Action = {
            let fetchRequest: NSFetchRequest<CoinENT> = CoinENT.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@", "name")
            let results = try? self.coreDataManager.viewContext.fetch(fetchRequest)
            if let results = results?.first {
                for item in data {
                    results.name = item.name
                    results.price = item.currentPrice ?? 0
                    results.priceChange24H = item.priceChange24H ?? 0
                    results.priceChangePercentage24H = item.priceChangePercentage24H ?? 0
                    results.totalSupply = item.totalSupply ?? 0
                    results.marketCapRank = Int64(item.marketCapRank ?? 0)
                    results.marketCap = Int64(item.marketCap ?? 0)
                    results.low24H = item.low24H ?? 0
                    results.high24H = item.high24H ?? 0
                }
            }else{
                for item in data {
                    let coin = NSEntityDescription.insertNewObject(forEntityName: Constants.DB.coinENt, into: self.coreDataManager.viewContext)
                    coin.setValue(item.name, forKey: "name")
                    coin.setValue(item.currentPrice, forKey: "price")
                    coin.setValue(item.priceChange24H, forKey: "priceChange24H")
                    coin.setValue(item.priceChangePercentage24H, forKey: "priceChangePercentage24H")
                    coin.setValue(item.totalSupply, forKey: "totalSupply")
                    coin.setValue(item.marketCapRank, forKey: "marketCapRank")
                    coin.setValue(item.marketCap, forKey: "marketCap")
                    coin.setValue(item.low24H, forKey: "low24H")
                    coin.setValue(item.high24H, forKey: "high24H")
                }
            }
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
    
    func delete() throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoinENT.entityName)
        self.coreDataManager
            .publicher(delete: request)
            .sinkOnMain { completion in
                switch completion {
                case .failure(let error):
                    log("Saving Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { _ in }
            .store(in: subscriber)
    }
}

enum AverageCalculationError: Error {
    case noProducts
    case productWithNoPrice
}


