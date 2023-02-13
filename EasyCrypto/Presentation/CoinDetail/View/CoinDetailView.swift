//
//  CoinDetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import SwiftUI

struct CoinDetailView: View {
    
    var coinId: String
    
    var body: some View {
        NavigationView {
                ZStack {
                    Color.darkBlue
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 30) {
//                        DetailHeaderView(item: item)
////                        PriceView(item: item)
//                            .padding(.horizontal)
//                        Divider()
//                            .background(Color.white.opacity(0.5))
//                            .padding(.horizontal)
//                        CoinDetailView(item: item)
//                        Spacer()
                    }
                    .padding(.top)
                }
        }.navigationBarTitle("")
         .navigationBarHidden(true)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coinId: "bitcoin")
    }
}
//
//struct DetailHeaderView: View {
//
//    var item: Coin
//
//    var body: some View {
//        HStack {
//            Button {
//
//            } label: {
//                Image(Assets.back)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 25.0, height: 15.5)
//            }
//            Spacer()
//            Text("Bitcoin(btc)")
//                .foregroundColor(Color.white)
//                .font(FontManager.body)
//            Spacer()
//        }
//        .padding(.horizontal)
//    }
//}

//struct PriceView: View {
//
//    var item: Coin
//
//    var body: some View {
//        VStack {
//            HStack(spacing: 5) {
//                Image(Assets.hashtag)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20.0, height: 20.0)
//                Text(String(item.marketCapRank ?? 0))
//                    .foregroundColor(Color.gray)
//                    .font(FontManager.title)
//                Spacer()
//            }
//            HStack {
//                let price = CurrencyFormatter.sharedInstance.string(from: item.currentPrice as? NSNumber ?? 0)!
//                Text(price)
//                    .foregroundColor(Color.white)
//                    .font(FontManager.headLine)
//                Spacer()
//                if let url = URL(string: item.safeImageURL()) {
//                    AsyncImage(
//                        url: url,
//                        placeholder: {ActivityIndicator(style: .medium, animate: .constant(true))
//                                .configure {
//                                    $0.color = .white
//                                } },
//                        image: { Image(uiImage: $0)
//                            .resizable() })
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 40.0, height: 40.0)
//                }
//            }
//            .padding(.top)
//            HStack {
//                let priceChange = CurrencyFormatter.sharedInstance.string(from: item.priceChangePercentage24H as? NSNumber ?? 0)!
//                Text(priceChange)
//                    .foregroundColor(item.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
//                    .font(FontManager.title)
//                Spacer()
//            }
//        }
//    }
//}
