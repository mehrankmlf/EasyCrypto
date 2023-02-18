//
//  MainViewFactory.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import Foundation

protocol MainViewFactory {
    func makeMainView(coordinator : MainCoordinator) -> MainView
    func makeMainViewModel(coordinator : MainCoordinator) -> MainViewModel
    func makeMarketPriceUsecase(coordinator: MainCoordinator) -> MarketPriceUsecase
    func makSsearchMarketUsecase(coordinator: MainCoordinator) -> SearchMarketUsecase
    func makeMarketPriceRepo(coordinator: MainCoordinator) -> MarketPriceRepository
    func makeMarketSearchRepo(coordinator: MainCoordinator) -> SearchMarketRepository
}
