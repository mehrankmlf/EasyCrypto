//
//  AppDependencyAssembler.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import Foundation

// an alternative way to replace singletons
fileprivate let sharedDependencyAssembler : AppDependencyAssembler = AppDependencyAssembler()

protocol DependencyAssemblerInjector {
    var dependencyAssembler : AppDependencyAssembler { get }
}

extension DependencyAssemblerInjector {
    var dependencyAssembler : AppDependencyAssembler {
        return sharedDependencyAssembler
    }
}

final class AppDependencyAssembler {
     init() {}
}

// MARK: - MainView
extension AppDependencyAssembler: MainViewFactory {
    func makeMainView(coordinator: MainCoordinator) -> MainView {
        return MainView(viewModel: self.makeMainViewModel(coordinator: coordinator))
    }
    func makeMainViewModel(coordinator: MainCoordinator) -> MainViewModel {
        return MainViewModel(marketPriceUsecase: self.makeMarketPriceUsecase(coordinator: coordinator),
                             searchMarketUsecase: self.makSsearchMarketUsecase(coordinator: coordinator))
    }
    func makeMarketPriceUsecase(coordinator: MainCoordinator) -> MarketPriceUsecase {
        return MarketPriceUsecase(marketPriceRepository: self.makeMarketPriceRepo(coordinator: coordinator))
    }
    func makSsearchMarketUsecase(coordinator: MainCoordinator) -> SearchMarketUsecase {
        return SearchMarketUsecase(searchMarketRepository: self.makeMarketSearchRepo(coordinator: coordinator))
    }
    func makeMarketPriceRepo(coordinator: MainCoordinator) -> MarketPriceRepository {
        return MarketPriceRepository(service: MarketPriceRemote())
    }
    func makeMarketSearchRepo(coordinator: MainCoordinator) -> SearchMarketRepository {
        return SearchMarketRepository(service: SearchMarketDataRemote())
    }
}


// MARK: - MainView
extension AppDependencyAssembler: CoinDetailViewFactory {
    func makeCoinDetailView() -> CoinDetailView {
        return CoinDetailView(viewModel: self.makeCoinDetailViewModel())
    }
    
    func makeCoinDetailViewModel() -> CoinDetailViewModel {
        return CoinDetailViewModel(coinDetailUsecase: self.makeCoinDetailUsecase())
    }
    
    func makeCoinDetailUsecase() -> CoinMarketUsecase {
        return CoinMarketUsecase(coinDetailRepository: self.makeCoinDetailRepo())
    }
    
    func makeCoinDetailRepo() -> CoinDetailRepository {
        return CoinDetailRepository(service: CoinDetailRemote())
    }
}
