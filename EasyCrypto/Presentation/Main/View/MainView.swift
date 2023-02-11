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
    
    private let buttonHeight: CGFloat = 55
    
    @State private var shouldShowDropdown = true
    @State private var selectedOption: Coin? = nil
    var onOptionSelected: ((_ option: Coin) -> Void)?
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let geoSize = geo.size
                ZStack {
                    Color.darkBlue
                        .ignoresSafeArea()
                    VStack(spacing: 20) {
                        HeaderView(viewModel: viewModel)
                        SearchBar(text: $viewModel.searchText, isLoading: $viewModel.isShowActivity, shouldShow: $shouldShowDropdown)
                            .padding(.horizontal, 5)
                            .overlay(
                                VStack {
                                    if self.shouldShowDropdown {
                                        Spacer(minLength: buttonHeight + 10)
                                        Dropdown(options: viewModel.searchData, onOptionSelected: { option in
                                            shouldShowDropdown = false
                                            selectedOption = option
                                            self.onOptionSelected?(option)
                                            viewModel.searchData = []
                                        })
                                        .padding(.horizontal)
                                        
                                    }
                                }, alignment: .topLeading
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 5).fill(Color.clear)
                            )
                            .zIndex(1)
                        SortView()
                        ScrollView {
                            ForEach(self.viewModel.marketData) { item  in
                                NavigationLink(destination: DetailView(item: item)){
                                    CryptoCellView(model: item)
                                }
                            }
                        }
                        .overlay (
                            SpinnerViewHandler(geoSize: geoSize,
                                               isShowing: $viewModel.isShowActivity)
                        )
                        .frame(width: geoSize.width)
                    }
                }
                .onAppear {
                    self.viewModel.apply(.onAppear)
                }
            }
        }
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    @Binding var isLoading: Bool
    @Binding var shouldShow: Bool
    @State private var isEditing = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                TextField("", text: $text)
                    .background(Color.clear)
                    .foregroundColor(.white)
                    .font(FontManager.headLine_2)
                    .placeHolder(Text("Search").font(FontManager.headLine_2).foregroundColor(.white.opacity(0.3)), show: text.isEmpty)
                    .onTapGesture(perform: {
                        isEditing = true
                    })

                if !text.isEmpty {
                    if isLoading {
                        Button(action: {
                            text = ""
                        }, label: {
                            ActivityIndicator(style: .medium, animate: .constant(true))
                                .configure {
                                    $0.color = .white
                                }
                        })
                        .frame(width: 35, height: 35)
                        
                    } else {
                        Button(action: {
                            text = ""
                            self.isEditing = false
                            self.shouldShow = false
                            dismissKeyboard()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .frame(width: 35, height: 35)
                        }).frame(width: 35, height: 35)
                    }
                }
//
//                if isEditing {
//                    Button(action: {
//                        text = ""
//                        isEditing = false
//                        dismissKeyboard()
//                    }, label: {
//                        Text("Cancel")
//                            .foregroundColor(.white)
//                    })
//                    .padding(.trailing, 10)
//                    .transition(.move(edge: .trailing))
//                    .animation(.default)
//                }
//
                
            }.padding(.horizontal)
             .frame(height: 40.0)
        }
    }
}

struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show { placeHolder }
            content
        }
    }
}

extension View {
    func placeHolder<T:View>(_ holder: T, show: Bool) -> some View {
        self.modifier(PlaceHolder(placeHolder:holder, show: show))
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    let style: UIActivityIndicatorView.Style
    @Binding var animate: Bool
    
    private let spinner: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView(style: .medium))
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        spinner.style = style
        return spinner
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        animate ? uiView.startAnimating() : uiView.stopAnimating()
    }
    
    func configure(_ indicator: (UIActivityIndicatorView) -> Void) -> some View {
        indicator(spinner)
        return self
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

//struct SearchBar: UIViewRepresentable {
//
//    @Binding var text: String
//    var placeholder: String
//
//    class Coordinator: NSObject, UISearchBarDelegate {
//
//        @Binding var text: String
//
//        init(text: Binding<String>) {
//            _text = text
//        }
//
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//        }
//    }
//
//    func makeCoordinator() -> SearchBar.Coordinator {
//        return Coordinator(text: $text)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
//        let searchBar = UISearchBar(frame: .zero)
//        searchBar.delegate = context.coordinator
//        searchBar.placeholder = placeholder
//        searchBar.searchBarStyle = .minimal
//        searchBar.autocapitalizationType = .none
//        searchBar.searchTextField.tintColor = UIColor.white
//        searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.1)
//        searchBar.searchTextField.textColor = .white
//        searchBar.barTintColor = UIColor.white
//        return searchBar
//    }
//
//    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
//        uiView.text = text
//    }
//}

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
    
    var model: Coin
    
    var body: some View {
        HStack {
            if let url = URL(string: model.safeImageURL()) {
                AsyncImage(
                    url: url,
                    placeholder: { Text("Loading ...") },
                    image: { Image(uiImage: $0)
                        .resizable() })
                .aspectRatio(contentMode: .fit)
                .frame(width: 25.0, height: 25.0)
            }
            Text(model.name ?? "")
                .foregroundColor(Color.black)
                .font(FontManager.body)
            Text("(\(model.symbol ?? "")")
                .foregroundColor(Color.black)
                .font(FontManager.body)
            Spacer()
            Text("#" + String(model.marketCapRank ?? 0))
                .foregroundColor(Color.black)
                .font(FontManager.body)
        }
        .padding(.vertical, 5)
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
