//
//  MainViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol MainViewModelInterface {
    func getMarketData(vs_currency: String,
                       order: String,
                       sparkline: Bool)
}

protocol DefaultMainViewModel: MainViewModelInterface, DataFlowProtocol  {}

final class MainViewModel: DefaultViewModel, DefaultMainViewModel {
    
    typealias InputType = _Input
    
    enum _Input {
        case onAppear
    }
    
    func apply(_ input: _Input) {
        switch input {
        case .onAppear:
            self.bindData()
            self.callFirstTime()
        }
    }
    
    enum SortType {
        case rankASC
        case rankDSC
    }
    
    let title: String = Constants.Title.mainTitle
    
    private let marketPriceUsecase: MarketPriceUsecaseProtocol
    private let searchMarketUsecase: SearchMarketUsecaseProtocol
    private let cacherepository: MarketPriceCacheRepositoryProtocol
    
    var page: Int = 1
    var perPage: Int = 15
    
    @Published var searchText: String = ""
    @Published var rankSort: SortType = .rankASC
    @Published private(set) var marketData: [MarketsPrice] = []
    @Published private(set) var wishListData: [MarketsPrice] = []
    @Published private(set) var searchData: [Coin] = []
    
    var navigateSubject = PassthroughSubject<MainView.Routes, Never>()
    
    init(marketPriceUsecase: MarketPriceUsecaseProtocol = DIContainer.shared.inject(type: MarketPriceUsecaseProtocol.self)!,
         searchMarketUsecase: SearchMarketUsecaseProtocol = DIContainer.shared.inject(type: SearchMarketUsecaseProtocol.self)!,
         cacherepository: MarketPriceCacheRepositoryProtocol = DIContainer.shared.inject(type: MarketPriceCacheRepositoryProtocol.self)!) {
        self.marketPriceUsecase = marketPriceUsecase
        self.searchMarketUsecase = searchMarketUsecase
        self.cacherepository = cacherepository
    }
    
    private func bindData() {
        $searchText
            .debounce(for: 1.0, scheduler: WorkScheduler.mainThread)
            .removeDuplicates()
            .sink { text in
                if text.isEmpty {
                    self.searchData = []
                }else{
                    guard self.searchData.count == 0 else {return}
                    self.searchMarketData(text: text.lowercased())
                }
            }.store(in: subscriber)
    }
    
    func didTapFirst(item: MarketsPrice) {
        self.navigateSubject.send(.first(item: item))
    }
    
    func didTapSecond(id: String) {
        self.navigateSubject.send(.second(id: id))
    }
    
    func callFirstTime() {
        guard self.marketData.count == 0 else {return}
        self.getMarketData()
    }
    
    func loadMore() {
        self.getMarketData()
    }
    
    func getMarketData(vs_currency: String = "usd",
                       order: String = "market_cap_desc",
                       sparkline: Bool = false) {
        self.callWithProgress(argument: self.marketPriceUsecase.execute(vs_currency: vs_currency,
                                                                        order: order,
                                                                        per_page: self.perPage,
                                                                        page: self.page,
                                                                        sparkline: sparkline)) { [ weak self] data in
            guard let data = data else {return}
            self?.marketData.append(contentsOf: data)
            self?.page += 1
        }
    }
    
    func searchMarketData(text: String) {
        self.callWithProgress(argument: self.searchMarketUsecase.execute(text: text)) { [weak self] data in
            let coin = data?.coins ?? []
            self?.searchData = []
            self?.searchData = coin
        }
    }
    
    func sortList(type: SortType) {
        switch type {
        case .rankASC:
            self.marketData.sort {
                $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0
            }
        case .rankDSC:
            self.marketData.sort {
                $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0
            }
        }
    }
    
    func fetchWishlist() {
       let _ = self.cacherepository.fetch()
            .map({ items in
            items.forEach { coin in
                self.wishListData.append(MarketsPrice(name: coin.name,
                                                      image: coin.image,
                                                      currentPrice: coin.price,
                                                      marketCap: Int(coin.marketCap),
                                                      marketCapRank: Int(coin.marketCapRank),
                                                      high24H: coin.high24H,
                                                      low24H: coin.low24H,
                                                      priceChange24H: coin.priceChange24H,
                                                      priceChangePercentage24H: coin.priceChangePercentage24H,
                                                      totalSupply: coin.totalSupply))
            }
        })
    }
}

