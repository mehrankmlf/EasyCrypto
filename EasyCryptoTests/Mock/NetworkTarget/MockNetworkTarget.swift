//
//  MockNetworkTarget.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
@testable import EasyCrypto

class MockNetworkTarget: NetworkTarget {
    var baseURL: EasyCrypto.BaseURLType = .baseApi
    
    var version: EasyCrypto.VersionType = .v1
    
    var path: String? = "/path"
    
    var methodType: EasyCrypto.HTTPMethod = .get
    
    var queryParams: [String : String]? = ["test": "test"]
    
    var queryParamsEncoding: EasyCrypto.URLEncoding? = .default
}
