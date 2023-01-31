//
//  NetworkTarget.swift
//  Amadeus
//
//  Created by Mehran Kamalifard on 9/7/22.
//

import Foundation

protocol NetworkTarget {
    var baseURL: BaseURLType { get }
    var version : VersionType { get }
    var path: String? { get }
    var methodType: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var queryParamsEncoding: URLEncoding? { get }
    var bodyEncoding: BodyEncoding? { get }
    var parameters:  [String: Any]? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
    var timeoutInterval: TimeInterval? { get }
    var headers: [String: String]? { get }
    var authorization: AuthorizationType { get }
}
