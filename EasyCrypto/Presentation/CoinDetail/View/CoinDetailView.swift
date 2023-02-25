//
//  CoinDetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import SwiftUI
import SafariServices

struct CoinDetailView: Coordinatable {
    
    typealias Route = Routes
    
    var id: String?
    
    var coinData: CoinUnitDetail {
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
                                CoinDetailTopView(item: coinData, url: { url in
                                    self.viewModel.didTapFirst(url: url ?? "")
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
                    self.viewModel.apply(.onAppear(id: self.id ?? ""))
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

struct SafariView: UIViewControllerRepresentable {

    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        return SFSafariViewController(url: url, configuration: configuration)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

struct CoinDetailTopView: View {
    
    var item: CoinUnitDetail
    var url: ((String?) -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            HStack {
                ImageView(withURL: item.image?.safeImageURL() ?? "")
                                    .frame(width: 50.0, height: 50.0)
                Spacer()
                CoinRankView(image: Assets.hashtag, rank: item.marketCapRank ?? 0)
                CoinRankView(image: Assets.coinGeckod, rank: item.coingeckoRank ?? 0)
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(item.name ?? "")
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
                Spacer()
                    .frame(width: 100)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Symbol")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                    Text(item.symbol ?? "")
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Link")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Button {
                    self.url(item.links?.homepage?.first ?? "")
                } label: {
                    Text(item.links?.homepage?.first ?? "")
                        .foregroundColor(Color.white)
                        .font(FontManager.title)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Description")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
                Text(item.description?.en ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(FontManager.title)
            }
        }
    }
}

struct CoinRankView: View {
    
    var image: String
    var rank: Int
    
    var body: some View {
        HStack(spacing: 5) {
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
