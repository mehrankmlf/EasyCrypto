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
    
    typealias InputType = Input
    
    enum Input {
        case onAppear
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            self.bindData()
            self.handleState()
            self.callFirstTime()
        }
    }
    
    enum SortType {
        case rankASC
        case rankDSC
    }
    
    let title: String = Constants.mainTitle
    
    private let marketPriceUsecase: MarketPriceUsecaseProtocol
    private let searchMarketUsecase: SearchMarketUsecaseProtocol
    
    var page: Int = 1
    var perPage: Int = 15
    
    @Published var isShowActivity : Bool = false
    @Published var searchText: String = ""
    @Published private(set) var marketData: [MarketsPrice] = []
    @Published private(set) var searchData: [Coin] = []
    @Published var rankSort: SortType = .rankASC
    
    var navigateSubject = PassthroughSubject<MainView.Routes, Never>()
    
    init(marketPriceUsecase: MarketPriceUsecaseProtocol = DIContainer.shared.resolve(type: MarketPriceUsecaseProtocol.self)!,
         searchMarketUsecase: SearchMarketUsecaseProtocol = DIContainer.shared.resolve(type: SearchMarketUsecaseProtocol.self)!) {
        self.marketPriceUsecase = marketPriceUsecase
        self.searchMarketUsecase = searchMarketUsecase
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
}

extension MainViewModel {
    private func handleState() {
        self.loadinState
            .receive(on: WorkScheduler.mainThread)
            .sink { [weak self] state in
                switch state {
                case .loadStart:
                    self?.isShowActivity = true
                case .dismissAlert:
                    self?.isShowActivity = false
                case .emptyStateHandler(let title):
                    print(title)
                }
            }.store(in: subscriber)
    }
}
