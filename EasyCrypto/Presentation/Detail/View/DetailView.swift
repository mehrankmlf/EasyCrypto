//
//  DetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/19/1401 AP.
//

import SwiftUI

struct DetailView: View {

    @StateObject var viewModel: DetailViewModel = DetailViewModel()

    var marketPrice: MarketsPrice?

    init(item: MarketsPrice? = nil) {
        self.marketPrice = item
    }

    var body: some View {
        content
    }

    var content: some View {
        ZStack {
            Color.darkBlue
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: .hugeSpace) {
                    if let item = self.marketPrice {
                        PriceView(marketPrice: item, viewModel: viewModel)
                            .padding(.horizontal)
                            .padding(.top)
                    }
                    Divider()
                        .background(Color.white.opacity(0.5))
                        .padding(.horizontal)
                    if let item = self.marketPrice {
                        CoinDetailAreaView(marketPrice: item)
                    }
                    Spacer()
                }
                .padding(.top)
            }
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
        .navigationBarColor(backgroundColor: Color.darkBlue.uiColor(), titleColor: .white)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: MarketsPrice.mock)
    }
}
