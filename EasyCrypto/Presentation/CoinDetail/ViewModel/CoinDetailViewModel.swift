//
//  ViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation
import Combine

protocol CoinDetailViewModelProtocol {
    func getCoinDetailData(id: String)
}

protocol DefaultCoinDetailViewModel: CoinDetailViewModelProtocol { }

final class CoinDetailViewModel: DefaultViewModel, DefaultCoinDetailViewModel {

    private let coinDetailUsecase: CoinDetailUsecaseProtocol

    @Published private(set) var coinData: CoinUnit?
    let errorTitle: String = Constants.Title.errorTitle
    let navigateSubject = PassthroughSubject<CoinDetailView.Routes, Never>()

    init(coinDetailUsecase: CoinDetailUsecaseProtocol = DIContainer.shared.inject(type: CoinDetailUsecaseProtocol.self)!) {
        self.coinDetailUsecase = coinDetailUsecase
    }
}

extension CoinDetailViewModel: DataFlowProtocol {

    typealias InputType = Load

    enum Load {
        case onAppear(id: String)
    }

    func apply(_ input: Load) {
        switch input {
        case .onAppear(let id):
            getCoinDetailData(id: id)
        }
    }

    func didTapFirst(url: String) {
        guard let url = URL(string: url) else { return }
        navigateSubject.send(.first(url: url))
    }

    func getCoinDetailData(id: String) {
        guard !id.isEmpty else { return }
        call(argument: coinDetailUsecase.execute(id: id)) { [weak self] data in
            guard let data = data else { return }
            self?.coinData = data
        }
    }
}
