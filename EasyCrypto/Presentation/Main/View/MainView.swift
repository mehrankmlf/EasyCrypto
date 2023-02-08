//
//  MainView.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI
import Combine

struct MainView: View {
    
    @ObservedObject private(set) var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBlue
                    .ignoresSafeArea()
                VStack(spacing: 30) {
                    HeaderView()
                    MarkertValueView()
                    SortView()
                    CryptoCellView()
                    Spacer()
                }
            }
        }
        .onAppear {
            self.viewModel.getMarketData(vs_currency: "usd",
                                         order: "market_cap_desc",
                                         per_page: 100,
                                         page: 1,
                                         sparkline: false)
        }
    }
}

struct HeaderView: View {
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(Assets.magnifier)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
            }
            Spacer()
            Text(Constants.mainTitle)
                .foregroundColor(Color.white)
                .font(FontManager.body)
            Spacer()
            Button {
                
            } label: {
                Image(Assets.sort)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal)
    }
}

struct MarkertValueView: View {
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("14,2572.65")
                    .foregroundColor(Color.white)
                    .font(FontManager.headLine)
                Text("+285.25")
                    .foregroundColor(Color.lightGreen)
                    .font(FontManager.title)
            }
            .padding(.horizontal)
            Spacer()
            ZStack{}
        }
    }
}


struct SortView: View {
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Rectangle()
                    .frame(width: 130.0, height: 30.0)
                    .foregroundColor(Color.white.opacity(0.1))
                    .cornerRadius(5.0)
                    .overlay {
                        Text("Highest Holding")
                            .foregroundColor(Color.white)
                            .font(FontManager.body)
                    }
            }
            Spacer()
            Button {
                
            } label: {
                Rectangle()
                    .frame(width: 90.0, height: 30.0)
                    .foregroundColor(Color.white.opacity(0.1))
                    .cornerRadius(5.0)
                    .overlay {
                        Text("24 Hours")
                            .foregroundColor(Color.white)
                            .font(FontManager.body)
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct CryptoCellView: View {
    
    var body: some View {
        HStack {
            Image("bitcoin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30.0, height: 30.0)
            VStack(spacing: 5) {
                Text("Bitcoin")
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text("2 TLCV")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
            }.padding(.leading, 5)
            Spacer()
            VStack(spacing: 5) {
                Text("23456")
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text("+ 74.9")
                    .foregroundColor(Color.lightGreen)
                    .font(FontManager.body)
            }
        }
        .padding(.horizontal)
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(marketPriceUsecase: MarketPriceUsecase(marketPriceRepository: MarketPriceRepository(service: MarketPriceRemote()))))
    }
}
