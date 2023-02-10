//
//  SearchMarketUsecase.swift
//  EasyCrypto
//
//  Created by Mehran on 11/21/1401 AP.
//

import Foundation
import Combine

protocol SearchMarketUsecaseProtocol : AnyObject {
    func execute(text: String) -> AnyPublisher<SearchMarket?, APIError>
}

final class SearchMarketUsecase: SearchMarketUsecaseProtocol {
    
    private let searchMarketRepository: SearchMarketRepositoryProtocol
    
    init(searchMarketRepository: SearchMarketRepositoryProtocol) {
        self.searchMarketRepository = searchMarketRepository
    }
    
    func execute(text: String) -> AnyPublisher<SearchMarket?, APIError> {
        return self.searchMarketRepository.data(text: text)
    }
}
