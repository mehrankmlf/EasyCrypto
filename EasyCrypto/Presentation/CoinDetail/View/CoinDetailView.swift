//
//  CoinDetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import SwiftUI

struct CoinDetailView: View {
    
    var coin: Coin
    
    @ObservedObject private(set) var viewModel: CoinDetailViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    CoinDetailHeaderView(item: self.viewModel.coinData)
                    ScrollView {
                        VStack(spacing: 30) {
                            CoinDetailTopView(item: self.viewModel.coinData)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
            }.onAppear {
                self.viewModel.apply(.onAppear)
                self.viewModel.apply(.coinDetail(id: coin.id ?? ""))
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: Coin.mock, viewModel: CoinDetailViewModel(coinDetailUsecase: CoinMarketUsecase(coinDetailRepository: CoinDetailRepository(service: CoinDetailRemote())), coinData: CoinUnitDetail.mock))
    }
}

struct CoinDetailHeaderView: View {
    
    var item: CoinUnitDetail
    
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
            Text(item.name ?? "")
                .foregroundColor(Color.white)
                .font(FontManager.title)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct CoinDetailTopView: View {
    
    var item: CoinUnitDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            HStack {
                if let url = URL(string: item.image?.safeImageURL() ?? "") {
                    AsyncImage(
                        url: url,
                        placeholder: {ActivityIndicator(style: .medium, animate: .constant(true))
                                .configure {
                                    $0.color = .white
                                } },
                        image: { Image(uiImage: $0)
                            .resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50.0, height: 50.0)
                }
                Spacer()
                CoinRankView(image: Assets.hashtag, rank: item.marketCapRank ?? 0)
                CoinRankView(image: Assets.coinGeckod, rank: item.coingeckoRank ?? 0)
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(item.name ?? "")
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
                Spacer()
                    .frame(width: 100)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Symbol")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(item.symbol ?? "")
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Link")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Link(item.links?.homepage?.first ?? "", destination: URL(string: item.links?.homepage?.first ?? "")!)
                    .foregroundColor(Color.white)
                    .font(FontManager.title)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Description")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Text(item.description?.en ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(FontManager.title)
            }
        }
    }
}

struct CoinRankView: View {
    
    var image: String
    var rank: Int
    
    var body: some View {
        HStack(spacing: 5) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20.0, height: 20.0)
            Text(String(rank))
                .foregroundColor(Color.gray)
                .font(FontManager.title)
        }
    }
}
