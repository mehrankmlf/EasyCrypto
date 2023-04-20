//
//  MarketPriceRemote.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol MarketPricRemoteProtocol: AnyObject {
     func fetch(vs_currency:
                String,
                order: String,
                per_page: Int,
                page: Int,
                sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError>
}

final class MarketPriceRemote: NetworkClientManager<HttpRequest>, MarketPricRemoteProtocol {
    func fetch(vs_currency: String,
               order: String,
               per_page: Int,
               page: Int,
               sparkline: Bool) -> AnyPublisher<[MarketsPrice]?, APIError> {
        self.request(request: HttpRequest(request: MarketPriceRequest(vs_currency: vs_currency,
                                                 order: order,
                                                 per_page: per_page,
                                                 page: page,
                                                 sparkline: sparkline)),
                     scheduler: WorkScheduler.mainScheduler,
                     responseObject: [MarketsPrice]?.self)
    }
}

struct MarketPriceRequest: NetworkTarget {

    let vs_currency: String
    let order: String
    let per_page: Int
    let page: Int
    let sparkline: Bool

    init(vs_currency: String,
         order: String,
         per_page: Int,
         page: Int,
         sparkline: Bool
        ) {
        self.vs_currency = vs_currency
        self.order = order
        self.per_page = per_page
        self.page = page
        self.sparkline = sparkline
    }

    var baseURL: BaseURLType {
        return .baseApi
    }

    var version: VersionType {
        return .v3
    }

    var path: String? {
        return "/coins/markets"
    }

    var methodType: HTTPMethod {
        .get
    }

    var queryParams: [String: String]? {
        return ["vs_currency": vs_currency,
                "order": order,
                "per_page": String(per_page),
                "page": String(page),
                "sparkline": String(sparkline)]
    }

    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
