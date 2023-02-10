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

final class MainViewModel: DefaultViewModel, ObservableObject, DefaultMainViewModel {
    
    typealias InputType = Input
    
    enum Input {
        case onAppear
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            self.handleState()
            self.getMarketData()
        }
    }
    
    let title: String = Constants.mainTitle
    
    private let marketPriceUsecase: MarketPriceUsecaseProtocol
    private let searchMarketUsecase: SearchMarketUsecaseProtocol
    
    var page: Int = 1
    var perPage: Int = 20
    
    @Published var marketData: [MarketsPrice] = []
    @Published var searchData: [SearchMarket] = []
    @Published var isShowActivity : Bool = false
    
    init(marketPriceUsecase: MarketPriceUsecaseProtocol,
         searchMarketUsecase: SearchMarketUsecaseProtocol) {
        self.marketPriceUsecase = marketPriceUsecase
        self.searchMarketUsecase = searchMarketUsecase
    }
    
    func getMarketData(vs_currency: String = "usd",
                       order: String = "market_cap_desc",
                       sparkline: Bool = false) {
        self.callWithProgress(argument: self.marketPriceUsecase.execute(vs_currency: vs_currency,
                                                                                     order: order,
                                                                                     per_page: self.perPage,
                                                                                     page: self.page,
                                                                                     sparkline: sparkline)) { data in
            guard let data = data else {return}
            self.marketData = data
            self.page += 1
        }
    }
    
    func searchMarketData(text: String) {
        self.callWithProgress(argument: self.searchMarketUsecase.execute(text: text)) { data in
            guard let data = data else {return}
            self.searchData = data
        }
    }
}

extension MainViewModel {
    private func handleState() {
        self.loadinState
            .receive(on: WorkScheduler.mainThread)
            .sink { state in
                switch state {
                case .loadStart:
                    self.isShowActivity = true
                case .dismissAlert:
                    self.isShowActivity = false
                case .emptyStateHandler:
                    self.isShowActivity = false
                }
            }.store(in: &subscriber)
    }
}
