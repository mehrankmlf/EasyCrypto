//
//  ViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation
import Combine

protocol CoinDetailViewModelInterface {
    func getCoinDetailData(id: String)
}

protocol DefaultCoinDetailViewModel: CoinDetailViewModelInterface, DataFlowProtocol  {}

final class CoinDetailViewModel: DefaultViewModel, DefaultCoinDetailViewModel {
    
    typealias InputType = Input
    
    enum Input {
        case onAppear(id: String)
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear(let id):
            self.handleState()
            self.getCoinDetailData(id: id)
        }
    }
    
    private let coinDetailUsecase: CoinDetailUsecaseProtocol
    
    @Published private(set) var coinData = CoinUnit()
    @Published var isShowActivity : Bool = false
    
    var navigateSubject = PassthroughSubject<CoinDetailView.Routes, Never>()
    
    init(coinDetailUsecase: CoinDetailUsecaseProtocol = DIContainer.shared.inject(type: CoinDetailUsecaseProtocol.self)!) {
        self.coinDetailUsecase = coinDetailUsecase
    }
    
    func didTapFirst(url: String) {
        guard let url = URL(string: url) else {return}
        self.navigateSubject.send(.first(url: url))
    }
    
    func getCoinDetailData(id: String) {
        guard !String.isNilOrEmpty(string: id) else {return}
        self.callWithProgress(argument: self.coinDetailUsecase.execute(id: id)) { [weak self] data in
            guard let data = data else {return}
            self?.coinData = data
        }
    }
}

extension CoinDetailViewModel {
    private func handleState() {
        self.loadinState
            .receive(on: WorkScheduler.mainThread)
            .sink { [weak self] state in
                switch state {
                case .loadStart:
                    self?.isShowActivity = true
                case .dismissAlert:
                    self?.isShowActivity = false
                case .emptyStateHandler:
                    self?.isShowActivity = false
                }
            }.store(in: subscriber)
    }
}
