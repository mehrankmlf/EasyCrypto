//
//  Configuration.swift
//  Amadeus
//
//  Created by Mehran on 3/30/1401 AP.
//

import Foundation

enum BaseURLType {
    case baseApi
    case staging
    
    var desc : URL {
        
        switch self {
        case .baseApi :
            return URL("https://www.coingecko.com/api/")
        case .staging :
            return URL("https://www.coingecko.com/api/")
        }
    }
}

enum VersionType {
    case none
    case v1, v2, v3
    var desc : String {
        switch self {
        case .none:
            return ""
        case .v1:
            return "/v1"
        case .v2:
            return "/v2"
        case .v3:
            return "/v3"
        }
    }
}
