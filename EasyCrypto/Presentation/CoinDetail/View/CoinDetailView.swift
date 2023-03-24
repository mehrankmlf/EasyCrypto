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
    
    let subscriber = Subscriber()
    var id: String?
    var coinData: CoinUnit {
        return self.viewModel.coinData
    }
    
    init(id: String? = nil, viewModel: CoinDetailViewModel) {
        self.id = id
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
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
                        SpinnerView(isShowing: $isLoading, text: .constant(""), geoSize: geoSize) {
                            ScrollView {
                                VStack(spacing: Constant.spacing) {
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
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .onAppear {
                    self.viewModel.apply(.onAppear(id: self.id.orWhenNilOrEmpty("")))
                }
            }
        }.onAppear(perform: handleState)
    }
}


extension CoinDetailView {
    enum Routes: Routing {
        case first(url: URL?)
    }
}

extension CoinDetailView {
    private func handleState() {
        self.viewModel.loadinState
            .receive(on: WorkScheduler.mainThread)
            .sink { state in
                switch state {
                case .loadStart:
                    self.isLoading = true
                case .dismissAlert:
                    self.isLoading = false
                case .emptyStateHandler(_, _):
                    self.isLoading = false
                }
            }.store(in: subscriber)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(viewModel: CoinDetailViewModel())
    }
}






