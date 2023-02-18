//
//  DetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/19/1401 AP.
//

import SwiftUI

struct DetailView: View {
    
    var item: MarketsPrice
    
    var body: some View {
            ZStack {
                Color.darkBlue
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    PriceView(item: item)
                        .padding(.horizontal)
                        .padding(.top)
                    Divider()
                        .background(Color.white.opacity(0.5))
                        .padding(.horizontal)
                    CoinDetailAreaView(item: item)
                    Spacer()
                }
                .padding(.top)
            }.navigationBarTitle(item.name ?? "", displayMode: .inline)
             .navigationBarColor(backgroundColor: .clear, titleColor: .white)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: MarketsPrice.mock)
    }
}

struct PriceView: View {
    
    var item: MarketsPrice
    
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
                if let url = URL(string: item.safeImageURL()) {
                    AsyncImage(
                        url: url,
                        placeholder: { ActivityIndicator(style: .medium, animate: .constant(true) )
                                .configure {
                                    $0.color = .white
                                } },
                        image: { Image(uiImage: $0)
                            .resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40.0)
                }
            }
            .padding(.top)
            HStack {
                let priceChange = CurrencyFormatter.sharedInstance.string(from: item.priceChangePercentage24H as? NSNumber ?? 0)!
                Text(priceChange)
                    .foregroundColor(item.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
                    .font(FontManager.title)
                Spacer()
            }
        }
    }
}

struct CoinDetailAreaView: View {
    
    var item: MarketsPrice
    
    var body: some View {
        VStack(spacing: 30) {
            let marketCapFormat = item.marketCap?.formatUsingAbbrevation()
            CoinDetailReusableView(title: "Market Cap",
                                   price: marketCapFormat ?? "")
            let price24Hours = CurrencyFormatter.sharedInstance.string(from: item.priceChange24H as? NSNumber ?? 0)!
            CoinDetailReusableView(title: "Volume (24 Hours)",
                                   price: price24Hours)
            let circulatingSupply = DecimalFormatter().string(from: item.circulatingSupply as? NSNumber ?? 0)
            CoinDetailReusableView(title: "Circulating Supply",
                                   price: circulatingSupply ?? "-")
            let totalSupply = DecimalFormatter().string(from: item.totalSupply as? NSNumber ?? 0)
            CoinDetailReusableView(title: "Total Supply",
                                   price: totalSupply ?? "-")
            let low24H = CurrencyFormatter.sharedInstance.string(from: item.low24H as? NSNumber ?? 0)!
            CoinDetailReusableView(title: "Low (24 Hours)",
                                   price: low24H)
            let high24H = CurrencyFormatter.sharedInstance.string(from: item.high24H as? NSNumber ?? 0)!
            CoinDetailReusableView(title: "High (24 Hours)",
                                   price: high24H)
        }
        .padding(.horizontal)
    }
}

struct CoinDetailReusableView: View {
    
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
