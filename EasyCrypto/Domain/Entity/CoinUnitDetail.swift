//
//  CoinUnitDetail.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation

struct CoinUnitDetail: Decodable, Identifiable {
    let id, symbol, name: String?
    let description: Tion?
    let links: Links?
    let image: Image_Large?
    let marketCapRank, coingeckoRank: Int?

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
