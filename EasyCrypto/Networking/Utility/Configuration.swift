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
            return URL("https://test.api.amadeus.com")
        case .staging :
            return URL("https://test.api.amadeus.com")
        }
    }
}

enum VersionType {
    case none
    case v1, v2
    
    var desc : String {
        switch self {
        case .none :
            return ""
        case .v1 :
            return "/v1"
        case .v2 :
            return "/v2"
        }
    }
}
