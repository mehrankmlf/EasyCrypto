//
//  DetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/19/1401 AP.
//

import SwiftUI

struct DetailView: View {
    
    var id: String
    
    @ObservedObject private(set) var viewModel: DetailViewModel
    
    enum Constant {
        static let spacing: CGFloat = 30
    }
    
    var body: some View {
        ZStack {
            Color.darkBlue
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: Constant.spacing) {
                PriceView(item: id)
                    .padding(.horizontal)
                    .padding(.top)
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                CoinDetailAreaView(item: id)
                Spacer()
            }
            .padding(.top)
        }
        .navigationBarTitle(id.name.orWhenNilOrEmpty(""), displayMode: .inline)
        .navigationBarColor(backgroundColor: .clear, titleColor: .white)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: MarketsPrice.mock)
    }
}





