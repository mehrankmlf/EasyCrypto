//
//  CoinDetailRank.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct CoinRankView: View {

    var image: String
    var rank: Int

    var body: some View {
        HStack(spacing: .regularSpace) {
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
