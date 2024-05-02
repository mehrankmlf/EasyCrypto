//
//  CoinDetailHeaderView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CoinDetailHeaderView: View {

    var item: CoinUnit

    var url: ((String?) -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            HStack {
                ImageDownloaderView(withURL: item.image?.safeImageURL() ?? .empty)
                    .frame(width: 50.0, height: 50.0)
                Spacer()
                CoinRankView(image: Assets.hashtag, rank: item.marketCapRank ?? 0)
                CoinRankView(image: Assets.coinGeckod, rank: item.coingeckoRank ?? 0)
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(item.name.orWhenNilOrEmpty(.empty))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
                Spacer()
                    .frame(width: 100)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Symbol")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(item.symbol.orWhenNilOrEmpty(.empty))
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Link")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Button {
                    self.url(item.links?.homepage?.first.orWhenNilOrEmpty(.empty))
                } label: {
                    Text(item.links?.homepage?.first ?? .empty)
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Description")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Text(item.description?.en ?? .empty)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(FontManager.title)
            }
        }
    }
}
