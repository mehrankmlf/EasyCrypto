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
            ImageView(withURL: item.safeImageURL())
                .frame(width: 30.0, height: 30.0)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name.orWhenNilOrEmpty(""))
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text(item.symbol.orWhenNilOrEmpty(""))
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
            }
            .padding(.leading, 5)
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                if let price = CurrencyFormatter.sharedInstance.string(from: item.currentPrice as? NSNumber ?? 0) {
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
        .padding(.vertical, 5)
    }
}
