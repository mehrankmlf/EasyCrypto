//
//  SearchMarket.swift
//  EasyCrypto
//
//  Created by Mehran on 11/21/1401 AP.
//

import Foundation

struct SearchMarket: Decodable, Hashable {
    
    let coins: [Coin]?
    
    enum CodingKeys: String, CodingKey {
        case coins = "coins"
    }
}

extension SearchMarket {
    static let mock = SearchMarket.init(coins: Coin.mockArray)
}

struct Coin: Decodable, Hashable {
    let id, name, apiSymbol, symbol: String?
    let marketCapRank: Int?
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case apiSymbol = "api_symbol"
        case symbol = "symbol"
        case marketCapRank = "market_cap_rank"
        case large = "large"
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Coin {
    // make image url safe
    func safeImageURL() -> String {
        guard let url = self.large else {return ""}
        let safeURL = url.trimmingString()
        return safeURL
    }
}

extension Coin {
    static let mock = Coin.init(id: "zcoin",
                                name: "Firo",
                                apiSymbol: "zcoin",
                                symbol: "FIRO",
                                marketCapRank: 596,
                                large: "https://assets.coingecko.com/coins/images/479/large/firocoingecko.png")
}

extension Coin {
    static let mockArray: [Coin] = [
        .init(id: "zcoin",
             name: "Firo",
             apiSymbol: "zcoin",
             symbol: "FIRO",
             marketCapRank: 596,
             large: "https://assets.coingecko.com/coins/images/479/large/firocoingecko.png"),
        .init(id: "zcoin",
             name: "Firo",
             apiSymbol: "zcoin",
             symbol: "FIRO",
             marketCapRank: 596,
             large: "https://assets.coingecko.com/coins/images/479/large/firocoingecko.png")
    ]
}
