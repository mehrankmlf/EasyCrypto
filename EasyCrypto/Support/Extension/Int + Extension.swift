//
//  Int + Extension.swift
//  EasyCrypto
//
//  Created by Mehran on 11/22/1401 AP.
//

import Foundation

extension Int {
    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        let startValue = Double(abs(self))
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 2
        return numFormatter.string(from: NSNumber(value: value))!
    }
}
