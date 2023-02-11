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
        NavigationView {
                ZStack {
                    Color.darkBlue
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 30) {
                        DetailHeaderView(item: item)
                        PriceView(item: item)
                            .padding(.horizontal)
                        Divider()
                            .background(Color.white.opacity(0.5))
                            .padding(.horizontal)
                        CoinDetailView(item: item)
                        Spacer()
                    }
                    .padding(.top)
                }
        }.navigationBarTitle("")
         .navigationBarHidden(true)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: MarketsPrice.mock)
    }
}

struct DetailHeaderView: View {
    
    var item: MarketsPrice
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(Assets.back)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25.0, height: 15.5)
            }
            Spacer()
            Text("Bitcoin(btc)")
                .foregroundColor(Color.white)
                .font(FontManager.body)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct PriceView: View {
    
    var item: MarketsPrice
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Image(Assets.hashtag)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                Text(String(item.marketCapRank ?? 0))
                    .foregroundColor(Color.gray)
                    .font(FontManager.title)
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
                        placeholder: {ActivityIndicator(style: .medium, animate: .constant(true))
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

struct CoinDetailView: View {
    
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
