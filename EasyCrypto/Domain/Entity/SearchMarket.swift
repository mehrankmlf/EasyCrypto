//
//  SearchMarket.swift
//  EasyCrypto
//
//  Created by Mehran on 11/21/1401 AP.
//

import Foundation

struct SearchMarket: Codable {
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

extension SearchMarket {
    // make image url safe
    func safeImageURL() -> String {
        guard let url = self.large else {return ""}
        let safeURL = url.trimmingString()
        return safeURL
    }
}
