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
    func makeMainView() -> MainView {
        return MainView(viewModel: self.makeMainViewModel())
    }
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(marketPriceUsecase: self.makeMarketPriceUsecase(),
                             searchMarketUsecase: self.makSsearchMarketUsecase())
    }
    func makeMarketPriceUsecase() -> MarketPriceUsecase {
        return MarketPriceUsecase(marketPriceRepository: self.makeMarketPriceRepo())
    }
    func makSsearchMarketUsecase() -> SearchMarketUsecase {
        return SearchMarketUsecase(searchMarketRepository: self.makeMarketSearchRepo())
    }
    func makeMarketPriceRepo() -> MarketPriceRepository {
        return MarketPriceRepository(service: MarketPriceRemote())
    }
    func makeMarketSearchRepo() -> SearchMarketRepository {
        return SearchMarketRepository(service: SearchMarketDataRemote())
    }
}


// MARK: - CoinDetailView
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
