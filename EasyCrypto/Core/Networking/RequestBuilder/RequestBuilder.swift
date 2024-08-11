//
//  RequestBuilder.swift
//  
//
//  Created by Mehran on 8/12/1401 AP.
//

import Foundation

protocol RequestBuilder: NetworkTarget {
    init(request: NetworkTarget)
    var pathAppendedURL: URL { get }
    func setQuery(to urlRequest: inout URLRequest)
    func encodedBody() -> Data?
    func buildURLRequest() -> URLRequest
}
