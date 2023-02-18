//
//  CurrencyFormatter.swift
//  EasyCrypto
//
//  Created by Mehran on 11/22/1401 AP.
//

import Foundation
// old school way :D
final class CurrencyFormatter: NumberFormatter {
    
  required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)!
  }
  
  override init() {
    super.init()
    self.locale = NSLocale.current
    self.maximumFractionDigits = 2
    self.minimumFractionDigits = 2
    self.alwaysShowsDecimalSeparator = true
    self.numberStyle = .currency
  }
  
  class var sharedInstance: CurrencyFormatter {
    struct Static {
      static let instance = CurrencyFormatter()
    }
    return Static.instance
  }
}
