//
//  CurrencyFormatter.swift
//  EasyCrypto
//
//  Created by Mehran on 11/22/1401 AP.
//

import Foundation

class CurrencyFormatter: NumberFormatter {

    static let shared = CurrencyFormatter()

    private override init() {
        super.init()
        configureFormatter()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureFormatter() {
        locale = Locale.current
        maximumFractionDigits = 2
        minimumFractionDigits = 2
        alwaysShowsDecimalSeparator = true
        numberStyle = .currency
    }
}
