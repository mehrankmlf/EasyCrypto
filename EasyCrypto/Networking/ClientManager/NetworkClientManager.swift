//
//  NetworkClientManager.swift
//  Amadeus
//
//  Created by Mehran on 5/21/20.
//  Copyright © 2020 Mehran Kamalifard. All rights reserved.
//

import Foundation
import Combine
import os.log

class NetworkClientManager<Target: RequestBuilder> {
    
    typealias AnyPublisherResult<M> = AnyPublisher<M, APIError>
    
    var subscriber = Set<AnyCancellable>()

    // The URLSession client is use to call request with URLSession Data Task Publisher
    private let clientURLSession : NetworkClientProtocol

    public init(clientURLSession : NetworkClientProtocol = NetworkClient()) {
        self.clientURLSession = clientURLSession
    }
    
    func request<M, T>(request: Target,
                       decoder: JSONDecoder = .init(),
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisherResult<M> where M : Decodable, T : Scheduler {
        return clientURLSession.perform(with: request, decoder: decoder, scheduler: scheduler, responseObject: type)
    }
}




