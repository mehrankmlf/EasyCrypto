//
//  NetworkClient.swift
//  Amadeus
//
//  Created by Mehran on 7/6/1401 AP.
//

import Foundation
import Combine

final class NetworkClient : NetworkClientProtocol {

    /// Initializes a new URL Session Client.
    ///
    /// - parameter urlSession: The URLSession to use.
    ///     Default: `URLSession(configuration: .shared)`.
    ///
    
    let session : URLSession
    let debugger : BaseAPIDebuger
    var subscriber = Set<AnyCancellable>()
    let retryCount: Int = 2
    
    init(session : URLSession = .shared,
         debugger : BaseAPIDebuger = BaseAPIDebuger()) {
        self.session = session
        self.debugger = debugger
    }

    @discardableResult
    func perform<M, T>(with request: RequestBuilder, decoder: JSONDecoder, scheduler: T, responseObject type: M.Type) -> AnyPublisher<M, APIError> where M : Decodable, T : Scheduler {
        let urlRequest = request.buildURLRequest()
        print(urlRequest.url)
        return publisher(request: urlRequest)
            .receive(on: scheduler)
            .tryMap { result, response -> Data in
                return result
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                return error as! APIError
            }
            .eraseToAnyPublisher()
    }

    func publisher(request : URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        return self.session.dataTaskPublisher(for: request)
            .mapError { APIError.urlError($0) }
            .map { response -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                guard let httpResponse = response.response as? HTTPURLResponse else {
                    return Fail(error: APIError.invalidResponse(httpStatusCode: 0))
                        .eraseToAnyPublisher()
                }

                if !httpResponse.isResponseOK {
                    let error = NetworkClient.errorType(type: httpResponse.statusCode)
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                return Just(response)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
