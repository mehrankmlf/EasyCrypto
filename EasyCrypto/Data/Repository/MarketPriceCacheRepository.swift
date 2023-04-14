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
    func save(_ data: MarketsPrice) throws
    func fetch() throws -> [CoinENT]?
    func fetchItem(_ name: String) -> CoinENT?
    func findByID(_ matchID: String) -> CoinENT?
    func delete(_ name: String) throws
}

final class MarketPriceCacheRepository: MarketPriceCacheRepositoryProtocol {

    let coreDataManager: CoreDataManagerProtocol
    let subscriber = Cancelable()
    
    init(coreDataManager: CoreDataManagerProtocol = DIContainer.shared.inject(type: CoreDataManagerProtocol.self)!) {
        self.coreDataManager = coreDataManager
    }
    
    func save(_ item: MarketsPrice) {
        let action: Action = {
                if let name = item.name, let matchData = self.findByID(name) {
                    matchData.name = item.name
                    matchData.price = item.currentPrice ?? 0
                    matchData.priceChange24H = item.priceChange24H ?? 0
                    matchData.priceChangePercentage24H = item.priceChangePercentage24H ?? 0
                    matchData.totalSupply = item.totalSupply ?? 0
                    matchData.marketCapRank = Int64(item.marketCapRank ?? 0)
                    matchData.marketCap = Int64(item.marketCap ?? 0)
                    matchData.low24H = item.low24H ?? 0
                    matchData.high24H = item.high24H ?? 0
                }else{
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
    
    func fetchItem(_ name: String) -> CoinENT? {
        if let matchData = findByID(name) {
            return matchData
        }
        return nil
    }
    
//    func delete() throws {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoinENT.entityName)
//        self.coreDataManager
//            .publicher(delete: request)
//            .sinkOnMain { completion in
//                switch completion {
//                case .failure(let error):
//                    log("Saving Failure: \(error)")
//                case .finished:
//                    log("Completion")
//                }
//            } receiveValue: { _ in }
//            .store(in: subscriber)
//    }
}

extension MarketPriceCacheRepository {
    func findByID(_ matchID: String) -> CoinENT? {
        let request: NSFetchRequest<CoinENT> = CoinENT.fetchRequest()
        let idPredicate = NSPredicate(format: "name == %@", matchID)
        request.predicate = idPredicate
        var result: [AnyObject]?
        var coinENT: CoinENT? = nil
        do {
            result = try self.coreDataManager.viewContext.fetch(request)
        } catch let error as NSError {
            NSLog("Error getting match: \(error)")
            result = nil
        }
        if result != nil {
            for resultItem : AnyObject in result! {
                coinENT = resultItem as? CoinENT
            }
        }
        return coinENT
    }
    
    func delete(_ name: String) throws {
        let request: NSFetchRequest<CoinENT> = CoinENT.fetchRequest()
        let idPredicate = NSPredicate(format: "name == %@", name)
        request.predicate = idPredicate
        do {
            let objects = try self.coreDataManager.viewContext.fetch(request)
            for object in objects {
                self.coreDataManager.viewContext.delete(object)
            }
            try self.coreDataManager.viewContext.save()
        } catch _ {
            // error handling
        }
    }
}


