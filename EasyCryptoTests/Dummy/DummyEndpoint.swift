//
//  FakeEndpoint.swift
//  EasyCryptoTests
//
//  Created by Mehran on 12/18/1401 AP.
//

import Foundation
@testable import EasyCrypto

final class DummyTarget: NetworkTarget {
    var baseURL: EasyCrypto.BaseURLType = .baseApi
    
    var version: EasyCrypto.VersionType = .v1
    
    var path: String? = "test/test"
    
    var methodType: EasyCrypto.HTTPMethod = .get
    
    var queryParams: [String : String]? = ["item": "item"]
    
    var queryParamsEncoding: EasyCrypto.URLEncoding? = .default
}
