//
//  ViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation

protocol CoinDetailViewModelInterface {
    func getCoinDetailData(id: String)
}

protocol DefaultCoinDetailViewModel: CoinDetailViewModelInterface, DataFlowProtocol  {}

final class CoinDetailViewModel: DefaultViewModel, ObservableObject, DefaultCoinDetailViewModel {
  
    typealias InputType = Input
    
    enum Input {
        case onAppear
        case coinDetail(id: String)
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            print("")
        case .coinDetail(let id):
            self.getCoinDetailData(id: id)
        }
    }
    
    func getCoinDetailData(id: String) {
        
    }
}
