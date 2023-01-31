//
//  APIError.swift
//  Amadeus
//
//  Created by Mehran on 6/4/1401 AP.
//

import Foundation

enum APIError : Error {
    case general
    case timeout
    case pageNotFound
    case noData
    case noNetwork
    case unknownError
    case serverError
    case redirection
    case clientError
    case invalidResponse(httpStatusCode : Int)
    case statusMessage(message : String)
    case decodingError(Error)
    case connectionError(Error)
    case unauthorizedClient
    
    case urlError(URLError)
    case httpError(HTTPURLResponse)
    
    case type(Error)
}

extension APIError {
    ///Description of error
    var desc: String {
        
        switch self {
        case .general:                    return MessageHelper.serverError.general
        case .timeout:                    return MessageHelper.serverError.timeOut
        case .pageNotFound:               return MessageHelper.serverError.notFound
        case .noData:                     return MessageHelper.serverError.notFound
        case .noNetwork:                  return MessageHelper.serverError.noInternet
        case .unknownError:               return MessageHelper.serverError.general
        case .serverError:                return MessageHelper.serverError.serverError
        case .redirection:                return MessageHelper.serverError.redirection
        case .clientError:                return MessageHelper.serverError.clientError
        case .invalidResponse:            return MessageHelper.serverError.invalidResponse
        case .unauthorizedClient:         return MessageHelper.serverError.unauthorizedClient
        case .statusMessage(let message): return message
        case .decodingError(let error):   return "Decoding Error: \(error.localizedDescription)"
        case .connectionError(let error): return "Network connection Error : \(error.localizedDescription)"
        default : return MessageHelper.serverError.general
        }
    }
}

extension APIError {
    
    var isRetry : Bool {
        return shouldRetry || canRetryHTTPError
    }
    
  private var shouldRetry: Bool {
          if case let .urlError(urlError) = self {
              switch urlError.code {
              case .timedOut,
                   .cannotFindHost,
                   .cannotConnectToHost,
                   .networkConnectionLost,
                   .dnsLookupFailed,
                   .httpTooManyRedirects,
                   .resourceUnavailable,
                   .notConnectedToInternet,
                   .secureConnectionFailed,
                   .cannotLoadFromNetwork:
                  return true
              default:
                  break
              }
          }
          return false
      }
    
   private var canRetryHTTPError: Bool {
        if case let .httpError(response) = self {
            let code = response.statusCode
            if /* Too Many Requests */ code == 429 ||
                /* Service Unavailable */ code == 503 ||
                /* Request Timeout */ code == 408 ||
                /* Gateway Timeout */ code == 504 {
                return true
            }
        }
        return false
    }
}

extension NetworkClient {
    
    static func errorType(type : Int) -> APIError {
        switch type {
        case 300..<400:
            return APIError.redirection
        case 400..<500:
            return APIError.clientError
        case 500..<600:
            return APIError.serverError
        default:
            return otherErrorType(type : type)
        }
    }
    
    private static func otherErrorType(type: Int) -> APIError {
        switch type {
        case -1001:
            return APIError.timeout
        case -1009:
            return APIError.noNetwork
        default:
            return APIError.unknownError
        }
    }
}
