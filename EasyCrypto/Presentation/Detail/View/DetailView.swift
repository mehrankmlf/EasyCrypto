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
        ZStack {
            Color.darkBlue
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                PriceView(item: item)
                    .padding(.horizontal)
                    .padding(.top)
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                CoinDetailAreaView(item: item)
                Spacer()
            }
            .padding(.top)
        }.navigationBarTitle(item.name.orWhenNilOrEmpty(""), displayMode: .inline)
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: MarketsPrice.mock)
    }
}





