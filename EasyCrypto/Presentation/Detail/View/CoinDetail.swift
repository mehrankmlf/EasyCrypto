//
//  CoinDetail.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CoinDetailAreaView: View {
    
    let item: MarketsPrice
    
    var body: some View {
        VStack(spacing: 30) {
            let marketCapFormat = item.marketCap?.formatUsingAbbrevation()
            CoinDetailCell(title: Constants.PlaceHolder.marketCap,
                                   price: marketCapFormat.orWhenNilOrEmpty(""))
            if let price24Hours = CurrencyFormatter.sharedInstance.string(from: item.priceChange24H as? NSNumber ?? 0) {
                CoinDetailCell(title: Constants.PlaceHolder.volume24,
                                       price: price24Hours)
            }
            if let circulatingSupply = DecimalFormatter().string(from: item.circulatingSupply as? NSNumber ?? 0) {
                CoinDetailCell(title: Constants.PlaceHolder.circulatingSupply,
                               price: circulatingSupply)
            }
            if let totalSupply = DecimalFormatter().string(from: item.totalSupply as? NSNumber ?? 0) {
                CoinDetailCell(title: Constants.PlaceHolder.totalSupply,
                               price: totalSupply)
            }
            if let low24H = CurrencyFormatter.sharedInstance.string(from: item.low24H as? NSNumber ?? 0) {
                CoinDetailCell(title: Constants.PlaceHolder.low24h,
                               price: low24H)
            }
            if let high24H = CurrencyFormatter.sharedInstance.string(from: item.high24H as? NSNumber ?? 0) {
                CoinDetailCell(title: Constants.PlaceHolder.high24h,
                               price: high24H)
            }
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
