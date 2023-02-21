//
//  MainView.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI
import Combine

struct MainView: Coordinatable {
    
    typealias Route = Routes
    
    @ObservedObject private(set) var viewModel: MainViewModel
    @State private var searchText : String = ""
    
    private let searchHeight: CGFloat = 55
    
    @State private var shouldShowDropdown = false
    @State private var selectedOption: Coin? = nil
    var onOptionSelected: ((_ option: Coin) -> Void)?
    var onMarketDataSelected: ((_ option: MarketsPrice) -> Void)?
    
    init(viewModel: MainViewModel) {
     self.viewModel = viewModel
    }
    
//     init(viewModel: MainViewModel) {
//
//    }
//
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let geoSize = geo.size
                ZStack {
                    Color.darkBlue
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        SearchBar(text: $viewModel.searchText, isLoading: viewModel.isShowActivity, isEditing: $shouldShowDropdown)
                            .padding(.horizontal, 5)
                            .overlay(
                                VStack {
                                    if self.shouldShowDropdown {
                                        Spacer(minLength: searchHeight + 10)
                                        Dropdown(options: viewModel.searchData, onOptionSelected: { option in
                                            self.viewModel.didTapSecond(id: option.id ?? "")
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
                        SpinnerView(isShowing: $viewModel.isShowActivity, text: .constant(""), geoSize: geoSize) {
                            List {
                                ForEach(self.viewModel.marketData) { item  in
                                    CryptoCellView(item: item)
                                        .onTouchDownGesture {
                                            self.viewModel.didTapFirst(item: item)
                                        }
                                }
                                ActivityIndicator(style: .medium, animate: .constant(true))
                                    .onAppear {
                                        if !self.viewModel.isShowActivity {
                                            self.viewModel.loadMore()
                                        }
                                    }
                            }.listStyle(.plain)
    
//                            .listItemTint(.clear)
//                            .listRowBackground(.none)

                            //                                List {
                            //                                    ForEach(0..<viewModel.marketData.count, id: \.self, content: { index in
                            //                                        CryptoCellView(item: viewModel.marketData[index])
                            //                                            .onAppear {
                            //                                                if index == (viewModel.marketData.count - 1) {
                            //                                                    //if last item then call api with next page
                            //                                                    self.viewModel.getMarketData()
                            //                                                }
                            //                                            }
                            //                                            .onTouchDownGesture {
                            //                                                self.viewModel.didTapFirst(item: viewModel.marketData[index])
                            //                                            }
                            //                                    })
                            ////                                }
                            //                            }
                            
                        }
                    }
                    .frame(width: geoSize.width)
                }
                .onAppear {
                    self.viewModel.apply(.onAppear)
                    self.viewModel.getMarketData()
                }
            }.navigationBarTitle(viewModel.title, displayMode: .inline)
                .navigationBarColor(backgroundColor: .clear, titleColor: .white)
        }
    }
}

struct NavigationBarModifier: ViewModifier {
    
    var backgroundColor: UIColor?
    var titleColor: UIColor?
    
    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

extension MainView {
    enum Routes: Routing {
        case first(item: MarketsPrice)
        case second(id: String)
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    @State var isLoading: Bool
    @Binding var isEditing: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                TextField("", text: $text)
                    .background(Color.clear)
                    .foregroundColor(.white)
                    .font(FontManager.headLine_2)
                    .placeHolder(Text("Search coins").font(FontManager.headLine_2).foregroundColor(.white.opacity(0.3)), show: text.isEmpty)
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
                                    $0.color = .black
                                }
                        })
                        .frame(width: 35, height: 35)
                        
                    } else {
                        Button(action: {
                            text = ""
                            isEditing = false
                            dismissKeyboard()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                        }).frame(width: 35, height: 35)
                    }
                }
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
                    placeholder: {ActivityIndicator(style: .medium, animate: .constant(true))
                            .configure {
                                $0.color = .white
                            } },
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
            Text(model.marketCapRank != nil ? "#" + String(model.marketCapRank ?? 0) : "")
                .foregroundColor(Color.black)
                .font(FontManager.body)
        }
        .padding(.vertical, 5)
    }
}

struct CryptoCellView: View {
    
    var item: MarketsPrice
    
    var body: some View {
        HStack {
            if let url = URL(string: item.safeImageURL()) {
                AsyncImage(
                    url: url,
                    placeholder: {ActivityIndicator(style: .medium, animate: .constant(true))
                            .configure {
                                $0.color = .white
                            } },
                    image: { Image(uiImage: $0)
                        .resizable() })
                .aspectRatio(contentMode: .fit)
                .frame(width: 30.0, height: 30.0)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name ?? "")
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text(item.symbol ?? "")
                    .foregroundColor(Color.gray)
                    .font(FontManager.body)
            }
            .padding(.leading, 5)
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                let price = CurrencyFormatter.sharedInstance.string(from: item.currentPrice as? NSNumber ?? 0)!
                Text(price)
                    .foregroundColor(Color.white)
                    .font(FontManager.body)
                Text(String(item.priceChangePercentage24H ?? 0.0))
                    .foregroundColor(item.priceChangePercentage24H?.sign == .minus ? Color.red : Color.lightGreen)
                    .font(FontManager.body)
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.vertical, 5)
    }
}

extension View {
    func onTouchDownGesture(callback: @escaping () -> Void) -> some View {
        modifier(OnTouchDownGestureModifier(callback: callback))
    }
}

private struct OnTouchDownGestureModifier: ViewModifier {
    @State private var tapped = false
    let callback: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        self.tapped = true
                        self.callback()
                    }
                }
                .onEnded { _ in
                    self.tapped = false
                })
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(marketPriceUsecase: MarketPriceUsecase(marketPriceRepository: MarketPriceRepository(service: MarketPriceRemote())), searchMarketUsecase: SearchMarketUsecase(searchMarketRepository: SearchMarketRepository(service: SearchMarketDataRemote()))))
    }
}
