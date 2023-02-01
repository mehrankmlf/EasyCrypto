//
//  URL + Extension.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/31/23.
//

import Foundation

extension URL {
    init(_ string: StaticString) {
        self.init(string: "\(string)")!
    }
}
