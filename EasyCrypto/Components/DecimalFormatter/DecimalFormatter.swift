//
//  DecimalFormatter.swift
//  EasyCrypto
//
//  Created by Mehran on 11/22/1401 AP.
//

import Foundation
// old school way :D
final class DecimalFormatter: NumberFormatter {

    public override init() {
        super.init()
        locale = Locale.current
        numberStyle = .decimal
        minimumFractionDigits = 2
        maximumFractionDigits = 2
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return  }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
}
