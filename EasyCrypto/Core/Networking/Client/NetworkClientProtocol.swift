//
//  NetworkClientProtocol.swift
//  
//
//  Created by Mehran on 7/6/1401 AP.
//

import Foundation
import Combine

typealias BaseAPIProtocol = NetworkClientProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, APIError>

protocol NetworkClientProtocol: AnyObject {
    /// Sends the given request.
    ///
    /// - parameter request: The request to be sent.
    /// - parameter completion: A callback to invoke when the request completed.

    var session: URLSession { get }

    @available(iOS 13.0, *)
    @discardableResult
    func perform<M: Decodable, T>(with request: RequestBuilder,
                                  decoder: JSONDecoder,
                                  scheduler: T,
                                  responseObject type: M.Type) -> AnyPublisher<M, APIError> where M: Decodable, T: Scheduler
}

protocol Logging {
    func logRequest(request: URLRequest)
    func logResponse(response: URLResponse?, data: Data?)
}
