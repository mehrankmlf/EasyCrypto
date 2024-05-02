//
//  MarketsPrice.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation

struct MarketsPrice: Decodable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice: Double?
    let marketCap, marketCapRank: Int?
    let totalVolume, high24H, low24H, priceChange24H: Double?
    let priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    let totalSupply, maxSupply: Double?

    init(id: String? = nil,
         symbol: String? = nil,
         name: String? = nil,
         image: String? = nil,
         currentPrice: Double? = nil,
         marketCap: Int? = nil,
         marketCapRank: Int? = nil,
         totalVolume: Double? = nil,
         high24H: Double? = nil,
         low24H: Double? = nil,
         priceChange24H: Double? = nil,
         priceChangePercentage24H: Double? = nil,
         marketCapChange24H: Double? = nil,
         marketCapChangePercentage24H: Double? = nil,
         circulatingSupply: Double? = nil,
         totalSupply: Double? = nil,
         maxSupply: Double? = nil) {

        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case symbol = "symbol"
        case name = "name"
        case image = "image"
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
    }
}

extension MarketsPrice: Equatable {
    static func == (lhs: MarketsPrice, rhs: MarketsPrice) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MarketsPrice {
    // make image url safe
    func safeImageURL() -> String {
        guard let url = self.image else {return .empty}
        let safeURL = url.trimmingString()
        return safeURL
    }
}

extension MarketsPrice {
    static let mock = MarketsPrice.init(id: "test1", symbol: "test1", name: "test1", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 21747, marketCap: 419320825566, marketCapRank: 100, totalVolume: 50153133497, high24H: 22615, low24H: 21596, priceChange24H: -868.336685288763, priceChangePercentage24H: -3.83958, marketCapChange24H: -15645722770.546387, marketCapChangePercentage24H: -3.59699, circulatingSupply: 19286950, totalSupply: 21000000, maxSupply: 21000000)
    static let mockArray: [MarketsPrice] = [
        .init(id: "bit2", symbol: "btc", name: "bit2", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 21747, marketCap: 419320825566, marketCapRank: 1, totalVolume: 50153133497, high24H: 22615, low24H: 21596, priceChange24H: -868.336685288763, priceChangePercentage24H: -3.83958, marketCapChange24H: -15645722770.546387, marketCapChangePercentage24H: -3.59699, circulatingSupply: 19286950, totalSupply: 21000000, maxSupply: 21000000),
        .init(id: "bit3", symbol: "btc", name: "bit3", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 21747, marketCap: 419320825566, marketCapRank: 2, totalVolume: 50153133497, high24H: 22615, low24H: 21596, priceChange24H: -868.336685288763, priceChangePercentage24H: -3.83958, marketCapChange24H: -15645722770.546387, marketCapChangePercentage24H: -3.59699, circulatingSupply: 19286950, totalSupply: 21000000, maxSupply: 21000000),
        .init(id: "bit4", symbol: "btc", name: "bit4", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 21747, marketCap: 419320825566, marketCapRank: 3, totalVolume: 50153133497, high24H: 22615, low24H: 21596, priceChange24H: -868.336685288763, priceChangePercentage24H: -3.83958, marketCapChange24H: -15645722770.546387, marketCapChangePercentage24H: -3.59699, circulatingSupply: 19286950, totalSupply: 21000000, maxSupply: 21000000)
    ]
}
