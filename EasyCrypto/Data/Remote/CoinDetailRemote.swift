//
//  CoinDetailRemote.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import Foundation
import Combine

protocol CoinDetailRemoteProtocol: AnyObject {
    func fetch(id: String) -> AnyPublisher<CoinUnit?, APIError>
}

final class CoinDetailRemote: NetworkClientManager<HttpRequest>, CoinDetailRemoteProtocol {
    func fetch(id: String) -> AnyPublisher<CoinUnit?, APIError> {
        self.request(request: HttpRequest(request: CoinDetailRequest(id: id)),
                     scheduler: WorkScheduler.mainScheduler,
                     responseObject: CoinUnit?.self)
    }
}

struct CoinDetailRequest: NetworkTarget {

    let id: String

    init(id: String) {
        self.id = id
    }

    var baseURL: BaseURLType {
        return .baseApi
    }

    var version: VersionType {
        return .v3
    }

    var path: String? {
        return "/coins/\(id)"
    }

    var methodType: HTTPMethod {
        .get
    }

    var queryParams: [String: String]? {
        return nil
    }

    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
