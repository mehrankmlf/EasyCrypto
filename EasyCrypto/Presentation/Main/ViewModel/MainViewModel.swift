//
//  MainViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation

protocol MainViewModelInterface {
    func getMarketData(vs_currency: String,
                       order: String,
                       per_page: Int,
                       page: Int,
                       sparkline: Bool)
}

protocol DefaultMainViewModel: MainViewModelInterface {}

final class MainViewModel: DefaultViewModel,  DefaultMainViewModel  {

    private let marketPriceUsecase: MarketPriceUsecaseInterface
    
    init(marketPriceUsecase: MarketPriceUsecaseInterface) {
        self.marketPriceUsecase = marketPriceUsecase
    }
    
    func getMarketData(vs_currency: String,
                       order: String,
                       per_page: Int,
                       page: Int,
                       sparkline: Bool) {
        super.callWithProgress(argument: self.marketPriceUsecase.execute(vs_currency: vs_currency,
                                                                                     order: order,
                                                                                     per_page: per_page,
                                                                                     page: page,
                                                                         sparkline: sparkline)) { data in
            print(data)
        }

    }
}
