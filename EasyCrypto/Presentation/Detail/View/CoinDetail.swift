//
//  CoinDetail.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CoinDetailAreaView: View {
    
    var item: MarketsPrice
    
    var body: some View {
        VStack(spacing: 30) {
            let marketCapFormat = item.marketCap?.formatUsingAbbrevation()
            CoinDetailCell(title: "Market Cap",
                                   price: marketCapFormat.orWhenNilOrEmpty(""))
            if let price24Hours = CurrencyFormatter.sharedInstance.string(from: item.priceChange24H as? NSNumber ?? 0) {
                CoinDetailCell(title: "Volume (24 Hours)",
                                       price: price24Hours)
            }
            let circulatingSupply = DecimalFormatter().string(from: item.circulatingSupply as? NSNumber ?? 0)
            CoinDetailCell(title: "Circulating Supply",
                                   price: circulatingSupply ?? "-")
            let totalSupply = DecimalFormatter().string(from: item.totalSupply as? NSNumber ?? 0)
            CoinDetailCell(title: "Total Supply",
                                   price: totalSupply ?? "-")
            let low24H = CurrencyFormatter.sharedInstance.string(from: item.low24H as? NSNumber ?? 0)!
            CoinDetailCell(title: "Low (24 Hours)",
                                   price: low24H)
            let high24H = CurrencyFormatter.sharedInstance.string(from: item.high24H as? NSNumber ?? 0)!
            CoinDetailCell(title: "High (24 Hours)",
                                   price: high24H)
        }
        .padding(.horizontal)
    }
}

struct CoinDetailCell: View {
    
    var title: String
    var price: String
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Text(price)
                    .foregroundColor(Color.white)
                    .font(FontManager.title)
            }
            Spacer()
        }
    }
}
