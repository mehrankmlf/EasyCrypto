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
                       per_page: Int,
                       page: Int,
                       sparkline: Bool)
}

protocol DefaultMainViewModel: MainViewModelInterface, DataFlowProtocol  {}

final class MainViewModel: DefaultViewModel, ObservableObject, DefaultMainViewModel {
    
    typealias InputType = Input
    
    enum Input {
        case onAppear(vs_currency: String,
                      order: String,
                      per_page: Int,
                      page: Int,
                      sparkline: Bool)
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear(let vs_currency,
                       let order,
                       let per_page,
                       let page,
                       let sparkline):
            self.getMarketData(vs_currency: vs_currency,
                               order: order,
                               per_page: per_page,
                               page: page,
                               sparkline: sparkline)
        }
    }
    

    private let marketPriceUsecase: MarketPriceUsecaseInterface
    
    init(marketPriceUsecase: MarketPriceUsecaseInterface) {
        self.marketPriceUsecase = marketPriceUsecase
    }
    
    func getMarketData(vs_currency: String,
                       order: String,
                       per_page: Int,
                       page: Int,
                       sparkline: Bool) {
        self.callWithProgress(argument: self.marketPriceUsecase.execute(vs_currency: vs_currency,
                                                                                     order: order,
                                                                                     per_page: per_page,
                                                                                     page: page,
                                                                         sparkline: sparkline)) { data in
            print(data)
        }

    }
}
