//
//  NetworkType + Default.swift
//  Amadeus
//
//  Created by Mehran Kamalifard on 9/7/22.
//

import Foundation

extension NetworkTarget {
    var queryParams: [String : String]? {
        return nil
    }
    
    var queryParamsEncoding: URLEncoding? {
        return  nil
    }
    
    var bodyEncoding: BodyEncoding? {
        return nil
    }
    
    var parameters: [String : Any]? {
       return nil
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        return .useProtocolCachePolicy
    }
    
    var timeoutInterval: TimeInterval? {
        return 20.0
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorization: AuthorizationType {
        return .none
    }
}


