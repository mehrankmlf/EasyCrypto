//
//  MainView.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI
import Combine

struct MainView: View {
    
    var isShowContent : Bool = false
    @ObservedObject private(set) var viewModel: MainViewModel
    @State private var searchText : String = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let geoSize = geo.size
                ZStack {
                    Color.darkBlue
                        .ignoresSafeArea()
                    VStack(spacing: 30) {
                        HeaderView(viewModel: viewModel)
                        SearchBar(text: $searchText, placeholder: "Search in coins")
                            .padding(.horizontal, 5)
                        SortView()
                        ScrollView {
                            ForEach(self.viewModel.marketData) { item  in
                                NavigationLink(destination: DetailView(item: item)){
                                    CryptoCellView(model: item)
                                }
                            }
                        }.overlay {
                            SpinnerViewHandler(geoSize: geoSize,
                                               isShowing: $viewModel.isShowActivity)
                        }
                    }
                }
                .onAppear {
                    self.viewModel.apply(.onAppear)
                }
            }
        }
    }
}
    
    struct HeaderView: View {
        
        @StateObject var viewModel: MainViewModel
        
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
                Text(viewModel.title)
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
    
    struct SearchBar: UIViewRepresentable {

        @Binding var text: String
        var placeholder: String

        class Coordinator: NSObject, UISearchBarDelegate {

            @Binding var text: String

            init(text: Binding<String>) {
                _text = text
            }

            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                text = searchText
            }
        }

        func makeCoordinator() -> SearchBar.Coordinator {
            return Coordinator(text: $text)
        }

        func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
            let searchBar = UISearchBar(frame: .zero)
            searchBar.delegate = context.coordinator
            searchBar.placeholder = placeholder
            searchBar.searchBarStyle = .minimal
            searchBar.autocapitalizationType = .none
            searchBar.searchTextField.tintColor = UIColor.white
            searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.1)
            searchBar.searchTextField.textColor = .white
            searchBar.barTintColor = UIColor.white
            return searchBar
        }

        func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
            uiView.text = text
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
    
    struct SearchMarketCellView: View {
        
        var model: SearchMarket
        
        var body: some View {
            HStack {
                if let url = URL(string: model.safeImageURL()) {
                    AsyncImage(
                        url: url,
                        placeholder: { Text("Loading ...") },
                        image: { Image(uiImage: $0)
                            .resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30.0, height: 30.0)
                }
                Text(model.name ?? "")
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text("(\(model.symbol ?? "")")
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Spacer()
                Text("#" + String(model.marketCapRank ?? 0))
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
        }
    }
    
    struct CryptoCellView: View {
        
        var model: MarketsPrice
        
        var body: some View {
            HStack {
                if let url = URL(string: model.safeImageURL()) {
                    AsyncImage(
                        url: url,
                        placeholder: { Text("Loading ...") },
                        image: { Image(uiImage: $0)
                            .resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30.0, height: 30.0)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(model.name ?? "")
                        .foregroundColor(Color.white)
                        .font(FontManager.body)
                    Text(model.symbol ?? "")
                        .foregroundColor(Color.gray)
                        .font(FontManager.body)
                }
                .padding(.leading, 5)
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text(String(model.price_CurrencyFormat))
                        .foregroundColor(Color.white)
                        .font(FontManager.body)
                    Text(String(model.priceChangePercentage24H ?? 0.0))
                        .foregroundColor(model.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
                        .font(FontManager.body)
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
        }
    }

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(marketPriceUsecase: MarketPriceUsecase(marketPriceRepository: MarketPriceRepository(service: MarketPriceRemote())), searchMarketUsecase: SearchMarketUsecase(searchMarketRepository: SearchMarketRepository(service: SearchMarketDataRemote()))))
    }
}
