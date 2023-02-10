//
//  Double + Extension.swift
//  EasyCrypto
//
//  Created by Mehran on 11/20/1401 AP.
//

import Foundation

extension Double {
    func currencyFormat() -> String {
        return self.formatted(.currency(code: "USD"))
    }
}
