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
        VStack(spacing: .hugeSpace) {
            coinDetailCells
        }
        .padding(.horizontal)
    }

    private var coinDetailCells: some View {
        Group {
            CoinDetailCell(
                title: Constants.PlaceHolder.marketCap,
                price: item.marketCap?.formatUsingAbbrevation() ?? .empty
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.volume24,
                value: item.priceChange24H?.toNSNumber,
                formatter: CurrencyFormatter.shared
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.circulatingSupply,
                value: item.circulatingSupply?.toNSNumber,
                formatter: DecimalFormatter()
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.totalSupply,
                value: item.totalSupply?.toNSNumber,
                formatter: DecimalFormatter()
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.low24h,
                value: item.low24H?.toNSNumber,
                formatter: CurrencyFormatter.shared
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.high24h,
                value: item.high24H?.toNSNumber,
                formatter: CurrencyFormatter.shared
            )
        }
    }
}

struct CoinDetailCell: View {

    var title: String
    var price: String

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: .regularSpace) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(FontManager.body)
                Text(price)
                    .foregroundColor(.white)
                    .font(FontManager.title)
            }
            Spacer()
        }
    }
}

struct CoinDetailCellIfAvailable: View {

    var title: String
    var value: NSNumber?
    var formatter: Formatter

    var body: some View {
        if let value = value,
           let formattedPrice = formatter.string(for: value) {
            CoinDetailCell(title: title, price: formattedPrice)
        } else {
            EmptyView()
        }
    }
}
