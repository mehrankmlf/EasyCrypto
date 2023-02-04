//
//  Encoding.swift
//  Amadeus
//
//  Created by Mehran Kamalifard on 9/4/22.
//

import Foundation

public enum URLEncoding: String {
    //Generally for these methods - GET, HEAD, DELETE, CONNECT, OPTIONS
    case `default`
    case percentEncoded
    //Always for POST/PUT METHOD
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}

public enum BodyEncoding: String {
    case JSON
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}
