//
//  MarketPriceCacheRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 1/5/1402 AP.
//

import Foundation
import CoreData
import Combine

protocol CacheRepositoryProtocol {
    func save(_ data: MarketsPrice) throws
    func fetch() -> [CoinENT]?
    func fetchItem(_ name: String) -> CoinENT?
    func findByID(_ matchID: String) -> CoinENT?
    func deleteByID(_ name: String) throws
}

final class MarketPriceCacheRepository: CacheRepositoryProtocol {

    let coreDataManager: CoreDataManagerProtocol
    let subscriber = Cancelable()

    init(coreDataManager: CoreDataManagerProtocol = DIContainer.shared.inject(type: CoreDataManagerProtocol.self)!) {
        self.coreDataManager = coreDataManager
    }

    func save(_ item: MarketsPrice) {
        let action: Action = {
            if let name = item.name, let matchData = self.findByID(name) {
                matchData.image = item.image
                matchData.name = item.name
                matchData.symbol = item.symbol
                matchData.price = item.currentPrice ?? 0
                matchData.priceChange24H = item.priceChange24H ?? 0
                matchData.priceChangePercentage24H = item.priceChangePercentage24H ?? 0
                matchData.totalSupply = item.totalSupply ?? 0
                matchData.marketCapRank = Int64(item.marketCapRank ?? 0)
                matchData.marketCap = Int64(item.marketCap ?? 0)
                matchData.low24H = item.low24H ?? 0
                matchData.high24H = item.high24H ?? 0
            } else {
                let coin = NSEntityDescription.insertNewObject(forEntityName: Constants.DBName.coinENt,
                                                               into: self.coreDataManager.viewContext)
                coin.setValue(item.image, forKey: "image")
                coin.setValue(item.name, forKey: "name")
                coin.setValue(item.symbol, forKey: "symbol")
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

    func fetch() -> [CoinENT]? {
        let request: NSFetchRequest<CoinENT> = CoinENT.fetchRequest()
        var output: [CoinENT] = []
        self.coreDataManager
            .publisher(fetch: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    log("FetchData Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { value in
                output.append(contentsOf: value)
            }.store(in: subscriber)
        return output
    }

    func fetchItem(_ name: String) -> CoinENT? {
        if let matchData = findByID(name) {
            return matchData
        }
        return nil
    }

    func findByID(_ id: String) -> CoinENT? {
        let request: NSFetchRequest<CoinENT> = CoinENT.fetchRequest()
        let idPredicate = NSPredicate(format: "name == %@", id)
        request.predicate = idPredicate
        var output: CoinENT?
        self.coreDataManager
            .publisher(fetch: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    log("FetchData Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { value in
                output = value.first
            }.store(in: subscriber)
        return output
    }

    func deleteByID(_ name: String) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoinENT.entityName)
        let idPredicate = NSPredicate(format: "name == %@", name)
        request.predicate = idPredicate
        self.coreDataManager
            .publisher(delete: request)
            .sinkOnMain { completion in
                switch completion {
                case .failure(let error):
                    log("Delete Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { _ in }
            .store(in: subscriber)
    }
}
