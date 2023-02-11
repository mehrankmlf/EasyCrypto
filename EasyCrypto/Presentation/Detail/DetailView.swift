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
            GeometryReader { geo in
                let geoSize = geo.size
                ZStack {
                    Color.darkBlue
                        .ignoresSafeArea()
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
                }
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
                    .frame(width: 25.0, height: 25.0)
                Text(String(item.marketCapRank ?? 0))
                    .foregroundColor(Color.gray)
                    .font(FontManager.title)
                Spacer()
            }
            HStack {
                Text(item.price_CurrencyFormat)
                    .foregroundColor(Color.white)
                    .font(FontManager.headLine)
                Spacer()
                if let url = URL(string: item.safeImageURL()) {
                    AsyncImage(
                        url: url,
                        placeholder: { Text("Loading ...") },
                        image: { Image(uiImage: $0)
                            .resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35.0, height: 35.0)
                }
            }
            .padding(.top)
            HStack {
                Text(String(item.priceChangePercentage24H ?? 0.0))
                    .foregroundColor(item.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
                    .font(FontManager.body)
                Spacer()
            }
        }
    }
}

struct CoinDetailView: View {
    
    var item: MarketsPrice
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Market Cap")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(String(item.marketCap ?? 0))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Volume (24 Hours)")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(String(item.priceChange24H ?? 0))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Circulating Supply")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(String(item.circulatingSupply ?? 0))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Supply")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(String(item.priceChange24H ?? 0))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Low (24 Hours)")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(String(item.low24H?.currencyFormat() ?? "0.0"))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("High (24 Hours)")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(String(item.high24H?.currencyFormat() ?? "0.0"))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            
        }
    }
}
