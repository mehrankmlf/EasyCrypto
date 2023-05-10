//
//  CoinUnitDetail.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation

struct CoinUnit: Decodable, Identifiable {
    var id, symbol, name: String?
    var description: Tion?
    var links: Links?
    var image: ImageLarge?
    var marketCapRank, coingeckoRank: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case symbol = "symbol"
        case name = "name"
        case description = "description"
        case links = "links"
        case image = "image"
        case marketCapRank = "market_cap_rank"
        case coingeckoRank = "coingecko_rank"
    }
}

struct Tion: Decodable {
    let en: String
}

struct ImageLarge: Decodable {
    let large: String?
}

struct Links: Decodable {
    let homepage: [String]?
}

extension ImageLarge {
    // make image url safe
    func safeImageURL() -> String {
        guard let url = self.large else {return .empty}
        let safeURL = url.trimmingString()
        return safeURL
    }
}

extension CoinUnit: Equatable {
    static func == (lhs: CoinUnit, rhs: CoinUnit) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CoinUnit {
    private static let tion = Tion.init(en: "Bitcoin is the first successful internet money based on peer-to-peer technology.")
    private static let links = Links.init(homepage: ["http://www.bitcoin.org"])
    private static let image = ImageLarge.init(large: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
    static let mock = CoinUnit.init(id: "bitcoin", symbol: "btc", name: "Bitcoin", description: tion, links: links, image: image, marketCapRank: 1, coingeckoRank: 1)
}
