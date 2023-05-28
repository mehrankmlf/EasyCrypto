//
//  Double + Extension.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 5/10/23.
//

import Foundation

extension Double {
    static let defaultValue = 0.0
}

extension Double {
    var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}
