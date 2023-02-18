//
//  CoinUnitDetail.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation

struct CoinUnitDetail: Decodable, Identifiable {
    var id, symbol, name: String?
    var description: Tion?
    var links: Links?
    var image: Image_Large?
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

    enum CodingKeys: String, CodingKey {
        case en = "en"
    }
}

struct Image_Large: Decodable {
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case large = "large"
    }
}

struct Links: Decodable {
    let homepage: [String]?

    enum CodingKeys: String, CodingKey {
        case homepage = "homepage"
    }
}

extension Image_Large {
    // make image url safe
    func safeImageURL() -> String {
        guard let url = self.large else {return ""}
        let safeURL = url.trimmingString()
        return safeURL
    }
}

extension CoinUnitDetail {
    private static let tion = Tion.init(en: "Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency")
    private static let links = Links.init(homepage: ["http://www.bitcoin.org"])
    private static let image = Image_Large.init(large: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
    static let mock = CoinUnitDetail.init(id: "bitcoin", symbol: "btc", name: "Bitcoin", description: tion, links: links, image: image, marketCapRank: 1, coingeckoRank: 1)
}
