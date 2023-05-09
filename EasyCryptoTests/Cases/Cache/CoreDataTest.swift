//
//  CoreDataTest.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/8/23.
//

import XCTest
import CoreData
import Combine
@testable import EasyCrypto

class CoreDataTest: CoreDataManager {
    
    var sut: CoreDataManagerProtocol!
    private var subscriber : Set<AnyCancellable> = []

    override func setUp() {
        sut = CoreDataManager()
    }

    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        sut = nil
        super.tearDown()
    }
}

extension CoreDataTest {
    func testCoreSave_WhenSaveData_ShouldSaveMockData() {
        
        let data = MarketsPrice.mock
        
        let mockAction: Action = {
            let coin = NSEntityDescription.insertNewObject(forEntityName: "CoinENT",
                                                           into: self.mockPersistentContainer.viewContext)
            coin.setValue(data.image, forKey: "image")
            coin.setValue(data.name, forKey: "name")
            coin.setValue(data.symbol, forKey: "symbol")
            coin.setValue(data.currentPrice, forKey: "price")
            coin.setValue(data.priceChange24H, forKey: "priceChange24H")
            coin.setValue(data.priceChangePercentage24H, forKey: "priceChangePercentage24H")
            coin.setValue(data.totalSupply, forKey: "totalSupply")
            coin.setValue(data.marketCapRank, forKey: "marketCapRank")
            coin.setValue(data.marketCap, forKey: "marketCap")
            coin.setValue(data.low24H, forKey: "low24H")
            coin.setValue(data.high24H, forKey: "high24H")
        }
        
        sut.publisher(save: mockAction)
            .sink { completion in
                
            } receiveValue: { state in
                XCTAssertEqual(state, true)
            }.store(in: &subscriber)
    }
}
