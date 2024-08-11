//
//  NetworkTarget + Extension.swift
//  
//
//  Created by Mehran Kamalifard on 9/7/22.
//

import Foundation

private struct HTTPHeader {
    static let contentLength = "Content-Length"
    static let contentType = "Content-Type"
    static let accept = "Accept"
    static let acceptEncoding = "Accept-Encoding"
    static let contentEncoding = "Content-Encoding"
    static let cacheControl = "Cache-Control"
    static let authorization = "Authorization"
}

struct HttpRequest: RequestBuilder {
    
    var baseURL: BaseURLType
    var version: VersionType
    var path: String?
    var methodType: HTTPMethod
    var queryParams: [String: String]?
    var queryParamsEncoding: URLEncoding?
    var headers: [String: String]?
    var parameters: [String: Any]?
    var bodyEncoding: BodyEncoding?
    var cachePolicy: URLRequest.CachePolicy?
    var timeoutInterval: TimeInterval?

    init(request: NetworkTarget) {
        self.baseURL = request.baseURL
        self.version = request.version
        self.path = request.path
        self.methodType = request.methodType
        self.queryParams = request.queryParams
        self.queryParamsEncoding = request.queryParamsEncoding
    }

    internal var pathAppendedURL: URL {
        var url = baseURL.desc
        url.appendPathComponent(version.desc)
        if let path = path {
            url.appendPathComponent(path)
        }
        return url
    }

    internal func setQuery(to urlRequest: inout URLRequest) {
        guard let url = urlRequest.url else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        switch queryParamsEncoding {
        case .default:
            urlComponents?.queryItems = queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        case .percentEncoded:
            urlComponents?.percentEncodedQueryItems = queryParams?.map {
                URLQueryItem(name: $0.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.key,
                             value: $0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)
            }
        case .xWWWFormURLEncoded:
            if let queryParamsData = queryParams?.urlEncodedQueryParams().data(using: .utf8) {
                urlRequest.httpBody = queryParamsData
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: HTTPHeader.contentType)
            }
        default:
            break
        }
        
        urlRequest.url = urlComponents?.url
    }

    internal func encodedBody() -> Data? {
        guard let bodyEncoding = bodyEncoding else { return nil }
        
        switch bodyEncoding {
        case .JSON:
            return try? JSONSerialization.data(withJSONObject: parameters ?? [:])
        case .xWWWFormURLEncoded:
            return try? parameters?.urlEncodedBody()
        }
    }

    func buildURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: pathAppendedURL)
        urlRequest.httpMethod = methodType.name
        urlRequest.allHTTPHeaderFields = headers
        
        if let queryParams = queryParams, !queryParams.isEmpty {
            setQuery(to: &urlRequest)
        }
        
        urlRequest.httpBody = encodedBody()
        urlRequest.cachePolicy = cachePolicy ?? .useProtocolCachePolicy
        urlRequest.timeoutInterval = timeoutInterval ?? 60
        
        return urlRequest
    }
}
