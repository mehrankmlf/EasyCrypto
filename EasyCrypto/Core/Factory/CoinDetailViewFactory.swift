//
//  CoinDetailViewFactory.swift
//  EasyCrypto
//
//  Created by Mehran on 11/28/1401 AP.
//

import Foundation

protocol CoinDetailViewFactory {
    func makeCoinDetailView() -> CoinDetailView
    func makeCoinDetailViewModel() -> CoinDetailViewModel
    func makeCoinDetailUsecase() -> CoinMarketUsecase
    func makeCoinDetailRepo() -> CoinDetailRepository
}
