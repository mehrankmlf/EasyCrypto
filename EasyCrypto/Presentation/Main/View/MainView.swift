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

    @State var index = 0
    @State private var shouldShowDropdown = false
    @State private var searchText: String = .empty
    @State private var isLoading: Bool = false

    let subscriber = Cancelable()

    init(viewModel: MainViewModel = DIContainer.shared.inject(type: MainViewModel.self)!) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    SearchBar(isLoading: isLoading,
                              text: $viewModel.searchText,
                              isEditing: $shouldShowDropdown)
                    .padding(.horizontal, 5)
                    .overlay(
                        VStack {
                            if self.shouldShowDropdown {
                                Spacer(minLength: Constant.searchHeight + 10)
                                Dropdown(options: viewModel.searchData,
                                         onOptionSelected: { option in
                                    self.viewModel.didTapSecond(id: option.id.orWhenNilOrEmpty(.empty))
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
                    SortView(viewModel: self.viewModel, viewState: isLoading)
                        .padding(.top, Constant.topPadding)
                    TabItemView(index: $index)
                        .padding(.top, 20)
                    TabView(selection: $index) {
                        if index == 0 {
                            coinsList()
                        } else {
                            whishList()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    Spacer()
                }
            }
            .navigationBarTitle(viewModel.title, displayMode: .inline)
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .onAppear {
                self.viewModel.apply(.onAppear)
            }
        }.onAppear(perform: handleState)
    }
    func coinsList() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.marketData, id: \.id) { item  in
                    CryptoCellView(item: item)
                        .onTapGesture {
                            self.viewModel.didTapFirst(item: item)
                        }
                }
                if isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: Constant.cornerRadius)
                            .foregroundColor(Color.white.opacity(0.8))
                            .frame(width: 40.0, height: 40.0)
                        ActivityIndicator(style: .medium, animate: .constant(true))
                    }
                } else {
                    Color.clear
                        .onAppear {
                            if !isLoading, !self.viewModel.marketData.isEmpty {
                                self.viewModel.loadMore()
                            }
                        }
                }
            }
            .padding()
        }
    }
    func whishList() -> some View {
        ScrollView {
            VStack {
                ForEach(viewModel.wishListData, id: \.symbol) { item  in
                    CryptoCellView(item: item)
                        .onTapGesture {
                            self.viewModel.didTapFirst(item: item)
                        }
                }
            }
            .padding()
        }.onAppear {
            self.viewModel.fetchWishlist()
        }
    }
}

extension MainView {
    enum Routes: Routing {
        case first(item: MarketsPrice)
        case second(id: String)
    }
}

extension MainView {
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
