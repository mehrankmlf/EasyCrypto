//
//  CryotoCell.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CryptoCellView: View {

    var item: MarketsPrice

    var body: some View {
        HStack {
            ImageDownloaderView(withURL: item.safeImageURL())
                .frame(width: 30.0, height: 30.0)
            VStack(alignment: .leading, spacing: .regularSpace) {
                Text(item.name.orWhenNilOrEmpty(.empty))
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text(item.symbol.orWhenNilOrEmpty(.empty))
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
            }
            .padding(.leading, .regularSpace)

            Spacer()

            VStack(alignment: .trailing, spacing: .regularSpace) {
                if let price = CurrencyFormatter.shared.string(from: item.currentPrice?.toNSNumber ?? 0) {
                    Text(price)
                        .foregroundColor(Color.white)
                        .font(FontManager.body)
                }
                Text(String(item.priceChangePercentage24H ?? 0.0))
                    .foregroundColor(item.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
                    .font(FontManager.body)
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.vertical, .regularSpace)
    }
}
