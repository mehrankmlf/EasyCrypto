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
            .retry(retryCount, unless: \.isRetry)
            .receive(on: scheduler)
            .tryMap { result, response -> Data in
                return result
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                if let error = error as? APIError {
                    switch error {
//                    case .unauthorizedClient:
//                        self.authorizationRequest.authenticateRequest()
//                            .sink { value in
//                                switch value {
//                                case true:
//                                     self.perform(with: request, decoder: decoder, scheduler: scheduler, responseObject: type)
//                                default :
//                                    break
//                                }
//                            }.store(in: &self.subscriber)
//
//                    default:
//                        break
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
    
    @discardableResult
    func request<M, T>(with request: RequestBuilder, decoder: JSONDecoder, scheduler: T, responseObject type: M.Type) -> AnyPublisher<M, APIError> where M : Decodable, T : Scheduler {
        let urlRequest = request.buildURLRequest()
        print(urlRequest)
        print(urlRequest.allHTTPHeaderFields)
        print(urlRequest.url)
        return self.session.dataTaskPublisher(for: urlRequest)
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    let error = APIError.connectionError(error)
                    throw error
                }
                self.debugger.log(request: urlRequest, error: error)
                return self.session.dataTaskPublisher(for: urlRequest)
            }
            .receive(on: scheduler)
            .tryMap { output, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = APIError.invalidResponse(httpStatusCode: 0)
                    throw error
                }
                if !httpResponse.isResponseOK {
                    let error = NetworkClient.errorType(type: httpResponse.statusCode)
                    self.debugger.log(request: urlRequest,error: error)
                    throw error
                }
                /// Return response to the Usecase
                return output
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    let error = APIError.decodingError(error)
                    return error
                }
            }.eraseToAnyPublisher()
    }
}
//
//extension NetworkClient {
//    func responsePublisher<M>(service: M) -> AnyPublisherResult<M> where M : Decodable {
//
//    }
//}

extension Publishers {
    struct RetryIf<P: Publisher>: Publisher {
        typealias Output = P.Output
        typealias Failure = P.Failure
        
        let publisher: P
        let times: Int
        let condition: (P.Failure) -> Bool
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            guard times > 0 else { return publisher.receive(subscriber: subscriber) }
            
            publisher.catch { (error: P.Failure) -> AnyPublisher<Output, Failure> in
                if condition(error)  {
                    return RetryIf(publisher: publisher, times: times - 1, condition: condition).eraseToAnyPublisher()
                } else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }.receive(subscriber: subscriber)
        }
    }
}

//extension Publisher {
//    func retry(times: Int, if condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
//        Publishers.RetryIf(publisher: self, times: times, condition: condition)
//    }
//}

extension Publisher {
    func retry(_ times: Int, if condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
        Publishers.RetryIf(publisher: self, times: times, condition: condition)
    }
    
    func retry(_ times: Int, unless condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
        retry(times, if: { !condition($0) })
    }
}

private extension Publisher {
    func failOrRetry<M, E>(
        _ retries: Int
    ) -> Publishers.TryCatch<Self, AnyPublisher<M, E>> where M == Self.Output, E == Self.Failure {
        tryCatch { error -> AnyPublisher<M, E> in
            if let error = error as? APIError, error.isRetry {
                return Publishers.Retry(upstream: self, retries: retries)
                    .eraseToAnyPublisher()
            }
            else {
                throw error
            }
        }
    }
}



/**
 Provides the retry behavior that will be used - the number of retries and the delay between two subsequent retries.
 - `.immediate`: It will immediatelly retry for the specified retry count
 - `.delayed`: It will retry for the specified retry count, adding a fixed delay between each retry
 - `.exponentialDelayed`: It will retry for the specified retry count.
 The delay will be incremented by the provided multiplier after each iteration
 (`multiplier = 0.5` corresponds to 50% increase in time between each retry)
 - `.custom`: It will retry for the specified retry count. The delay will be calculated by the provided custom closure.
 The closure's argument is the current retry
 */
enum RetryBehavior<S> where S: Scheduler {
    case immediate(retries: UInt)
    case delayed(retries: UInt, time: TimeInterval)
    case exponentialDelayed(retries: UInt, initial: TimeInterval, multiplier: Double)
    case custom(retries: UInt, delayCalculator: (UInt) -> TimeInterval)
}

fileprivate extension RetryBehavior {
    
    func calculateConditions(_ currentRetry: UInt) -> (maxRetries: UInt, delay: S.SchedulerTimeType.Stride) {
        
        switch self {
        case let .immediate(retries):
            // If immediate, returns 0.0 for delay
            return (maxRetries: retries, delay: .zero)
        case let .delayed(retries, time):
            // Returns the fixed delay specified by the user
            return (maxRetries: retries, delay: .seconds(time))
        case let .exponentialDelayed(retries, initial, multiplier):
            // If it is the first retry the initial delay is used, otherwise it is calculated
            let delay = currentRetry == 1 ? initial : initial * pow(1 + multiplier, Double(currentRetry - 1))
            return (maxRetries: retries, delay: .seconds(delay))
        case let .custom(retries, delayCalculator):
            // Calculates the delay with the custom calculator
            return (maxRetries: retries, delay: .seconds(delayCalculator(currentRetry)))
        }
        
    }
    
}

public typealias RetryPredicate = (Error) -> Bool

extension Publisher {
    /**
     Retries the failed upstream publisher using the given retry behavior.
     - parameter behavior: The retry behavior that will be used in case of an error.
     - parameter shouldRetry: An optional custom closure which uses the downstream error to determine
     if the publisher should retry.
     - parameter tolerance: The allowed tolerance in firing delayed events.
     - parameter scheduler: The scheduler that will be used for delaying the retry.
     - parameter options: Options relevant to the scheduler’s behavior.
     - returns: A publisher that attempts to recreate its subscription to a failed upstream publisher.
     */
    func retry<S>(
        _ behavior: RetryBehavior<S>,
        shouldRetry: RetryPredicate? = nil,
        tolerance: S.SchedulerTimeType.Stride? = nil,
        scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> AnyPublisher<Output, Failure> where S: Scheduler {
        return retry(
            1,
            behavior: behavior,
            shouldRetry: shouldRetry,
            tolerance: tolerance,
            scheduler: scheduler,
            options: options
        )
    }
    
    private func retry<S>(
        _ currentAttempt: UInt,
        behavior: RetryBehavior<S>,
        shouldRetry: RetryPredicate? = nil,
        tolerance: S.SchedulerTimeType.Stride? = nil,
        scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> AnyPublisher<Output, Failure> where S: Scheduler {
        
        // This shouldn't happen, in case it does we finish immediately
        guard currentAttempt > 0 else { return Empty<Output, Failure>().eraseToAnyPublisher() }
        
        // Calculate the retry conditions
        let conditions = behavior.calculateConditions(currentAttempt)
        
        return self.catch { error -> AnyPublisher<Output, Failure> in
            
            // If we exceed the maximum retries we return the error
            guard currentAttempt <= conditions.maxRetries else {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            if let shouldRetry = shouldRetry, shouldRetry(error) == false {
                // If the shouldRetry predicate returns false we also return the error
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            guard conditions.delay != .zero else {
                // If there is no delay, we retry immediately
                return self.retry(
                    currentAttempt + 1,
                    behavior: behavior,
                    shouldRetry: shouldRetry,
                    tolerance: tolerance,
                    scheduler: scheduler,
                    options: options
                )
                .eraseToAnyPublisher()
            }
            
            // We retry after the specified delay
            return Just(()).delay(for: conditions.delay, tolerance: tolerance, scheduler: scheduler, options: options).flatMap {
                return self.retry(
                    currentAttempt + 1,
                    behavior: behavior,
                    shouldRetry: shouldRetry,
                    tolerance: tolerance,
                    scheduler: scheduler,
                    options: options
                )
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        }
            .eraseToAnyPublisher()
    }
    
}
