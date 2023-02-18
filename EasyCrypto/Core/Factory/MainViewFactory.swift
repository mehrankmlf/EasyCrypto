//
//  MainViewFactory.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import Foundation

protocol MainViewFactory {
    func makeMainView() -> MainView
    func makeMainViewModel() -> MainViewModel
    func makeMarketPriceUsecase() -> MarketPriceUsecase
    func makSsearchMarketUsecase() -> SearchMarketUsecase
    func makeMarketPriceRepo() -> MarketPriceRepository
    func makeMarketSearchRepo() -> SearchMarketRepository
}
