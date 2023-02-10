//
//  SearchMarketDataRemote.swift
//  EasyCrypto
//
//  Created by Mehran on 11/21/1401 AP.
//

import Foundation
import Combine

protocol SearchMarketDataRemoteProtocol: AnyObject {
    func fetch(text: String) -> AnyPublisher<SearchMarket?, APIError>
}

final class SearchMarketDataRemote : NetworkClientManager<HttpRequest>, SearchMarketDataRemoteProtocol {
    func fetch(text: String) -> AnyPublisher<SearchMarket?, APIError> {
        self.request(request: HttpRequest(request: SearchMarketDataRequest(text: text)),
                     scheduler: WorkScheduler.mainScheduler,
                     responseObject: SearchMarket?.self)
    }
}

struct SearchMarketDataRequest : NetworkTarget {
    
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var baseURL: BaseURLType {
        return .baseApi
    }
    
    var version: VersionType {
        return .v3
    }
    
    var path: String? {
        return "/search"
    }
    
    var methodType: HTTPMethod {
        .get
    }
    
    var queryParams: [String : String]? {
        return ["query": text]
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
