//
//  NetworkClient.swift
//  
//
//  Created by Mehran on 7/6/1401 AP.
//

import Foundation
import Combine

final class NetworkClient: NetworkClientProtocol {

    /// Initializes a new URL Session Client.
    ///
    /// - Parameters:
    ///   - session: The URLSession to use. Default: `URLSession.shared`.
    ///   - logging: The logging utility to use. Default: `APIDebugger()`.
    ///
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
    
    let logging: Logging

    init(logging: Logging = APIDebugger()) {
        self.logging = logging
    }

    @discardableResult
    func perform<M, T>(with request: RequestBuilder,
                       decoder: JSONDecoder,
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisher<M, APIError> where M: Decodable, T: Scheduler {
        let urlRequest = request.buildURLRequest()
        self.logging.logRequest(request: urlRequest)
        return publisher(request: urlRequest)
            .receive(on: scheduler)
            .tryMap { result, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse(httpStatusCode: 0)
                }
                
                if httpResponse.isResponseOK {
                    return result
                } else {
                    // Attempt to decode error response
                    if let apiErrorResponse = try? decoder.decode(APIErrorResponse.self, from: result) {
                        throw APIError.statusMessage(message: apiErrorResponse.status.errorMessage)
                    } else {
                        throw APIError.invalidResponse(httpStatusCode: httpResponse.statusCode)
                    }
                }
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                // Improved error handling and logging
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                }
                return error as? APIError ?? .general
            }
            .eraseToAnyPublisher()
    }

    private func publisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        return self.session.dataTaskPublisher(for: request)
            .mapError { APIError.urlError($0) }
            .flatMap { response -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                self.logging.logResponse(response: response.response, data: response.data)
                return Just(response)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
