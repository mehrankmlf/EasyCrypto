//
//  DetailViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 1/13/1402 AP.
//

import Foundation

final class DetailViewModel: ObservableObject, DataFlowProtocol {
    
    typealias InputType = _Input
    
    enum _Input {
        case onAppear
    }
    
    func apply(_ input: _Input) {
        switch input {
        case .onAppear:
            self.fetchMarketPrice()
        }
    }
    
    
    @Published var data: MarketsPrice?
    
    private let repository: MarketPriceCacheRepositoryProtocol
    
    init(repository: MarketPriceCacheRepository = DIContainer.shared.inject(type: MarketPriceCacheRepository.self)!) {
        self.repository = repository
    }
    
    func fetchMarketPrice(_ name: String) {
        guard let item = self.repository.fetchItem(name) else {return}
        item.
    }
}
