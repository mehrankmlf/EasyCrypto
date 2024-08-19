//
//  APIErrorResponse.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2024/08/19.
//

import Foundation

struct APIErrorResponse: Decodable {
    
    let status: Status
}

struct Status: Decodable {
    
    let errorCode: Int
    let errorMessage: String
    
    private enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
