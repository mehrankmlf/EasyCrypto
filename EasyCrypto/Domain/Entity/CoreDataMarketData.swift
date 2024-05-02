//
//  CoreDataMarketData.swift
//  EasyCrypto
//
//  Created by Kamalifard, Mehran | TDD on 2024/05/02.
//

import Foundation

struct CoreDataMarketData {
    let id: String
    let symbol: String?
    let name: String?
    let image: String?
    let currentPrice: Double?
    let marketCap: Int?
    let marketCapRank: Int?
    let high24H: Double?
    let low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let totalSupply: Double?

    init(id: String,
         symbol: String?,
         name: String?,
         image: String?,
         currentPrice: Double?,
         marketCap: Int?,
         marketCapRank: Int?,
         high24H: Double?,
         low24H: Double?,
         priceChange24H: Double?,
         priceChangePercentage24H: Double?,
         totalSupply: Double?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.totalSupply = totalSupply
    }
}
