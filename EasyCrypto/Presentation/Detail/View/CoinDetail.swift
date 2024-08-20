//
//  CoinDetail.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CoinDetailAreaView: View {

    let marketPrice: MarketsPrice

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
                price: marketPrice.marketCap?.formatUsingAbbrevation() ?? .empty
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.volume24,
                value: marketPrice.priceChange24H?.toNSNumber,
                formatter: CurrencyFormatter.shared
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.circulatingSupply,
                value: marketPrice.circulatingSupply?.toNSNumber,
                formatter: DecimalFormatter()
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.totalSupply,
                value: marketPrice.totalSupply?.toNSNumber,
                formatter: DecimalFormatter()
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.low24h,
                value: marketPrice.low24H?.toNSNumber,
                formatter: CurrencyFormatter.shared
            )
            CoinDetailCellIfAvailable(
                title: Constants.PlaceHolder.high24h,
                value: marketPrice.high24H?.toNSNumber,
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
