//
//  HTTPURLResponse + Extension.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/31/23.
//

import Foundation

extension HTTPURLResponse {
    var isResponseOK: Bool {
        return (200..<299).contains(statusCode)
    }
}
