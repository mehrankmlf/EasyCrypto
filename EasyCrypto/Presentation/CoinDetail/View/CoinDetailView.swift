//
//  CoinDetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import SwiftUI

struct CoinDetailView: Coordinatable {

    typealias Route = Routes

    enum Constant {
        static let spacing: CGFloat = 30
        static let cornerRadius: CGFloat = 10
    }

    @ObservedObject private(set) var viewModel: CoinDetailViewModel

    @State private var isLoading: Bool = false
    @State private var presentAlert = false
    @State private var alertMessage: String = ""

    let subscriber = Cancelable()

    var id: String?
    var coinData: CoinUnit? {
        return self.viewModel.coinData
    }

    init(id: String? = nil, viewModel: CoinDetailViewModel) {
        self.id = id
        self.viewModel = viewModel
    }

    var body: some View {
        content
    }

    var content: some View {
        NavigationStack {
            GeometryReader { geo in
                let geoSize = geo.size
                ZStack {
                    Color.darkBlue
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geoSize.width / 3.5, height: 4)
                            .cornerRadius(Constant.cornerRadius)
                            .padding(.top)
                        SpinnerView(isShowing: $isLoading, text: .constant(.empty), geoSize: geoSize) {
                            ScrollView {
                                VStack(spacing: Constant.spacing) {
                                    if let unwrappedCoinData = coinData {
                                        CoinDetailHeaderView(item: unwrappedCoinData, url: { url in
                                            self.viewModel.didTapFirst(url: url.orWhenNilOrEmpty(.empty))
                                        })
                                        .padding(.horizontal)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top)
                        }
                    }
                }
                .navigationBarTitle(String.empty)
                .navigationBarHidden(true)
                .onAppear {
                    self.viewModel.apply(.onAppear(id: self.id.orWhenNilOrEmpty("")))
                }
                .handleViewModelState(viewModel: viewModel,
                                      isLoading: $isLoading,
                                      alertMessage: $alertMessage,
                                      presentAlert: $presentAlert)
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
        CoinDetailView(viewModel: CoinDetailViewModel())
    }
}
