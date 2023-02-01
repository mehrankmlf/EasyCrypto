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
        return publisher(request: urlRequest)
            .receive(on: scheduler)
            .tryMap { result, response -> Data in
                return result
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                if let error = error as? APIError {
                    switch error {
                    case .unauthorizedClient:
                        print("")
                    default:
                        break
                    }
                }
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

                if httpResponse.statusCode == 401 {
                    let error = APIError.unauthorizedClient
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                if httpResponse.statusCode >= 400 {
                    let error = APIError.httpError(httpResponse)
                    return Fail(error: error)
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
//
//extension Publishers {
//    struct RetryIf<P: Publisher>: Publisher {
//
//        typealias Output = P.Output
//        typealias Failure = P.Failure
//
//        let publisher: P
//        let times: Int
//        let condition: (P.Failure) -> Bool
//        
//        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
//            guard times > 0 else { return publisher.receive(subscriber: subscriber) }
//
//            publisher.catch { (error: P.Failure) -> AnyPublisher<Output, Failure> in
//                if condition(error)  {
//                    return RetryIf(publisher: publisher, times: times - 1, condition: condition).eraseToAnyPublisher()
//                } else {
//                    return Fail(error: error).eraseToAnyPublisher()
//                }
//            }.receive(subscriber: subscriber)
//        }
//    }
//}
//
//extension Publisher {
//    func retry(_ times: Int, if condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
//        Publishers.RetryIf(publisher: self, times: times, condition: condition)
//    }
//
//    func retry(_ times: Int, unless condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
//        retry(times, if: { !condition($0) })
//    }
//}
