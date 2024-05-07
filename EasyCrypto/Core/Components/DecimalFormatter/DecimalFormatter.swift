//
//  DecimalFormatter.swift
//  EasyCrypto
//
//  Created by Mehran on 11/22/1401 AP.
//

import Foundation

class DecimalFormatter: NumberFormatter {

    override init() {
        super.init()
        configureFormatter()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureFormatter() {
        locale = Locale.current
        numberStyle = .decimal
        minimumFractionDigits = 2
        maximumFractionDigits = 2
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        let cleanedString = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        obj?.pointee = NSNumber(value: (Double(cleanedString) ?? 0.0) / Double(pow(10.0, Double(minimumFractionDigits))))
    }
}
