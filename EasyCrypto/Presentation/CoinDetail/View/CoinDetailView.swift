//
//  CoinDetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import SwiftUI

struct CoinDetailView: Coordinatable {
    
    typealias Route = Routes
    
    var id: String?
    
    var coinData: CoinUnit {
        return self.viewModel.coinData
    }
    
    @ObservedObject private(set) var viewModel: CoinDetailViewModel
    
    init(id: String? = nil, viewModel: CoinDetailViewModel) {
        self.id = id
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            let geoSize = geo.size
            ZStack {
                Color.darkBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geoSize.width / 3.5, height: 4)
                        .cornerRadius(10.0)
                        .padding(.top)
                    SpinnerView(isShowing: $viewModel.isShowActivity, text: .constant(""), geoSize: geoSize) {
                        ScrollView {
                            VStack(spacing: 30) {
                                CoinDetailHeaderView(item: coinData, url: { url in
                                    self.viewModel.didTapFirst(url: url.orWhenNilOrEmpty(""))
                                })
                                .padding(.horizontal)
                            }
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
            }.navigationBarTitle("")
                .navigationBarHidden(true)
                .onAppear {
                    self.viewModel.apply(.onAppear(id: self.id.orWhenNilOrEmpty("")))
                }
        }
    }
}

extension CoinDetailView {
    enum Routes: Routing {
        case first(url: URL?)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(viewModel: CoinDetailViewModel(coinDetailUsecase: CoinMarketUsecase(coinDetailRepository: CoinDetailRepository(service: CoinDetailRemote()))))
    }
}






