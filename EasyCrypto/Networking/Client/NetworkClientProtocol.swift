//
//  HoverProtocol.swift
//  Hover
//
//  Created by Onur Cantay on 08/01/2022.
//  Copyright © 2022 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import Combine



protocol NetworkClientProtocol : AnyObject {
    /// Sends the given request.
    ///
    /// - parameter request: The request to be sent.
    /// - parameter completion: A callback to invoke when the request completed.
    
    var session: URLSession { get }
    
    func perform<M: Decodable, T>(with request: RequestBuilder, decoder: JSONDecoder, scheduler: T, responseObject type: M.Type) -> AnyPublisher<M, APIError> where M : Decodable, T : Scheduler
    
    @available(iOS 13.0, *)
    @discardableResult
    func request<M, T>(
        with request: RequestBuilder,
        decoder: JSONDecoder,
        scheduler: T,
        responseObject type: M.Type
    ) -> AnyPublisher<M, APIError> where M: Decodable, T: Scheduler
}

protocol DebuggerProtocol {
    var debugger : BaseAPIDebuger { get }
}

typealias BaseAPIProtocol = NetworkClientProtocol & DebuggerProtocol 

typealias AnyPublisherResult<M> = AnyPublisher<M, APIError>
