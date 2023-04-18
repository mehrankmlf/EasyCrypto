//
//  AppDependencyContainer + Injection.swift
//  EasyCrypto
//
//  Created by Mehran on 12/12/1401 AP.
//

import Foundation

extension DIContainer {
    func registration() {

       // Market price
        register(type: MarketPricRemoteProtocol.self, component: MarketPriceRemote())
        register(type: MarketPricRepositoryProrocol.self, component: MarketPriceRepository())
        register(type: CoreDataManagerProtocol.self, component: CoreDataManager())
        register(type: MarketPriceCacheRepositoryProtocol.self, component: MarketPriceCacheRepository())
        register(type: MarketPriceUsecaseProtocol.self, component: MarketPriceUsecase())
        
       // Search Market
        register(type: SearchMarketDataRemoteProtocol.self, component: SearchMarketDataRemote())
        register(type: SearchMarketRepositoryProtocol.self, component: SearchMarketRepository())
        register(type: SearchMarketUsecaseProtocol.self, component: SearchMarketUsecase())
        
        // Coin Unit
        register(type: CoinDetailRemoteProtocol.self, component: CoinDetailRemote())
        register(type: CoinDetailRepositoryProtocol.self, component: CoinDetailRepository())
        register(type: CoinDetailUsecaseProtocol.self, component: CoinMarketUsecase())
    }
}
