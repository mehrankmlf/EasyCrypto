//
//  MainViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    func getMarketData(vs_currency: String,
                       order: String,
                       sparkline: Bool)
}

protocol DefaultMainViewModel: MainViewModelProtocol { }

final class MainViewModel: DefaultViewModel, DefaultMainViewModel {

    let title: String = Constants.Title.mainTitle
    let errorTitle: String = Constants.Title.errorTitle

    private let marketPriceUsecase: MarketPriceUsecaseProtocol
    private let searchMarketUsecase: SearchMarketUsecaseProtocol
    private let cacheRepository: CacheRepositoryProtocol

    var page: Int = 1
    var perPage: Int = 15

    @Published var searchText: String = .empty
    @Published var rankSort: SortType = .rankASC
    @Published var marketData: [MarketsPrice] = []
    @Published private(set) var wishListData: [MarketsPrice] = []
    @Published private(set) var searchData: [Coin] = []

    var navigateSubject = PassthroughSubject<MainView.Routes, Never>()

    init(marketPriceUsecase: MarketPriceUsecaseProtocol = DIContainer.shared.inject(type: MarketPriceUsecaseProtocol.self)!,
         searchMarketUsecase: SearchMarketUsecaseProtocol = DIContainer.shared.inject(type: SearchMarketUsecaseProtocol.self)!,
         cacheRepository: CacheRepositoryProtocol = DIContainer.shared.inject(type: CacheRepositoryProtocol.self)!) {
        self.marketPriceUsecase = marketPriceUsecase
        self.searchMarketUsecase = searchMarketUsecase
        self.cacheRepository = cacheRepository
    }
}

extension MainViewModel: DataFlowProtocol {

    typealias InputType = Load

    enum Load {
        case onAppear
    }

    func apply(_ input: Load) {
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

    private func bindData() {
        $searchText
            .debounce(for: 1.0, scheduler: WorkScheduler.mainThread)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else {return}
                if text.isEmpty {
                    self.searchData = []
                } else {
                    guard self.searchData.isEmpty else {return}
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
        guard self.marketData.isEmpty else {return}
        self.getMarketData()
    }

    func loadMore() {
        self.getMarketData()
    }

    func getMarketData(vs_currency: String = "usd",
                       order: String = "market_cap_desc",
                       sparkline: Bool = false) {

        // Check if the number of market data entries is already 30 to limit service calls
        if marketData.count == 30 {
            return
        }

        self.call(argument: self.marketPriceUsecase.execute(vs_currency: vs_currency,
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
        self.call(argument: self.searchMarketUsecase.execute(text: text)) { [weak self] data in
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

    func fetchWishlistData() {
        cacheRepository.fetch()
            .map { items in
                self.wishListData = items.map { coin in
                    return MarketsPrice(symbol: coin.symbol,
                                        name: coin.name,
                                        image: coin.image,
                                        marketCap: Int(coin.marketCap),
                                        marketCapRank: Int(coin.marketCapRank),
                                        high24H: coin.high24H,
                                        low24H: coin.low24H,
                                        priceChange24H: coin.priceChange24H,
                                        priceChangePercentage24H: coin.priceChangePercentage24H,
                                        marketCapChangePercentage24H: Double(coin.marketCapRank),
                                        circulatingSupply: coin.circulatingSupply,
                                        totalSupply: coin.totalSupply)
                }
            }
    }
}
