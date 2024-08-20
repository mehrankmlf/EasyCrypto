//
//  CoinDetailHeaderView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CoinDetailHeaderView: View {

    var coinUnit: CoinUnit
    var url: (String?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .hugeSpace) {
            headerSection
            nameAndSymbolSection
            linkSection
            descriptionSection
        }
    }

    private var headerSection: some View {
        HStack {
            ImageDownloaderView(withURL: coinUnit.image?.safeImageURL() ?? .empty)
                .frame(width: 50.0, height: 50.0)
            Spacer()
            CoinRankView(image: Assets.hashtag, rank: coinUnit.marketCapRank ?? 0)
            CoinRankView(image: Assets.coinGeckod, rank: coinUnit.coingeckoRank ?? 0)
        }
    }

    private var nameAndSymbolSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: .regularSpace) {
                CoinDetailLabel(title: "Name", value: coinUnit.name.orWhenNilOrEmpty(.empty))
            }
            Spacer()
                .frame(width: 100)
            VStack(alignment: .leading, spacing: .regularSpace) {
                CoinDetailLabel(title: "Symbol", value: coinUnit.symbol.orWhenNilOrEmpty(.empty))
            }
        }
    }

    private var linkSection: some View {
        VStack(alignment: .leading, spacing: .regularSpace) {
            Text("Link")
                .foregroundColor(.gray)
                .font(FontManager.body)
            Button {
                url(coinUnit.links?.homepage?.first.orWhenNilOrEmpty(.empty))
            } label: {
                Text(coinUnit.links?.homepage?.first ?? .empty)
                    .foregroundColor(.white)
                    .font(FontManager.title)
            }
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: .regularSpace) {
            Text("Description")
                .foregroundColor(.gray)
                .font(FontManager.body)
            Text(coinUnit.description?.en ?? .empty)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .font(FontManager.title)
        }
    }
}

private struct CoinDetailLabel: View {

    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: .regularSpace) {
            Text(title)
                .foregroundColor(.gray)
                .font(FontManager.body)
            Text(value)
                .foregroundColor(.white)
                .font(FontManager.title)
        }
    }
}
