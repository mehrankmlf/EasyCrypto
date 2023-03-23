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
    
    enum Constant {
        static let searchHeight: CGFloat = 55
        static let topPadding: CGFloat = 5
        static let cornerRadius: CGFloat = 10
    }
    
    @State private var shouldShowDropdown = false
    @State private var searchText : String = ""
    
    let subscriber = Subscriber()
    
    init(viewModel: MainViewModel = DIContainer.shared.inject(type: MainViewModel.self)!) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    SearchBar(text: $viewModel.searchText,
                              isLoading: viewModel.isloading,
                              isEditing: $shouldShowDropdown)
                    .padding(.horizontal, 5)
                    .overlay(
                        VStack {
                            if self.shouldShowDropdown {
                                Spacer(minLength: Constant.searchHeight + 10)
                                Dropdown(options: viewModel.searchData,
                                         onOptionSelected: { option in
                                    self.viewModel.didTapSecond(id: option.id.orWhenNilOrEmpty(""))
                                })
                                .padding(.horizontal)
                            }
                        }, alignment: .topLeading
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.clear)
                    )
                    .zIndex(1)
                    .padding(.top, Constant.topPadding)
                    SortView(viewModel: self.viewModel)
                        .padding(.top, Constant.topPadding)
                    Spacer()
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.marketData, id: \.id) { item  in
                                CryptoCellView(item: item)
                                    .onTapGesture {
                                        self.viewModel.didTapFirst(item: item)
                                    }
                            }
                            if viewModel.isloading {
                                ZStack {
                                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                                        .foregroundColor(Color.white.opacity(0.8))
                                        .frame(width: 40.0, height: 40.0)
                                    ActivityIndicator(style: .medium, animate: .constant(true))
                                }
                                
                            }else {
                                Color.clear
                                    .onAppear {
                                        if !viewModel.isloading, self.viewModel.marketData.count > 0 {
                                            self.viewModel.loadMore()
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle(viewModel.title, displayMode: .inline)
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .onAppear {
                self.viewModel.apply(.onAppear)
            }
        }
    }
}

extension MainView {
    enum Routes: Routing {
        case first(item: MarketsPrice)
        case second(id: String)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
