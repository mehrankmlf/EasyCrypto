//
//  PriceView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct PriceView: View {
    
    let item: MarketsPrice
    
    var body: some View {
        VStack {
            HStack {
                CoinRankView(image: Assets.hashtag, rank: item.marketCapRank ?? 0)
                Text("Global Rank")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Spacer()
            }
            HStack {
                let price = CurrencyFormatter.sharedInstance.string(from: item.currentPrice as? NSNumber ?? 0)!
                Text(price)
                    .foregroundColor(Color.white)
                    .font(FontManager.headLine)
                Spacer()
                ImageView(withURL: item.safeImageURL())
                    .frame(width: 40.0, height: 40.0)
            }
            .padding(.top)
            HStack {
                if let priceChange = CurrencyFormatter.sharedInstance.string(from: item.priceChangePercentage24H as? NSNumber ?? 0) {
                    Text(priceChange)
                        .foregroundColor(item.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
                        .font(FontManager.title)
                    Spacer()
                }
            }
        }
    }
}
