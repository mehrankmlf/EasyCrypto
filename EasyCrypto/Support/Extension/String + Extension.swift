//
//  String + Extension.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation

extension String {
    
    static func isNilOrEmpty(string: String?) -> Bool {
        
        guard let value = string else { return true }

        return value.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isNumeric : Bool {
        return NumberFormatter().number(from: self) != nil
    }
    
    func trimmingAllSpaceString() -> String  {
         var strText = self;
         strText = strText.replacingOccurrences(of: " ", with: "")
         strText = strText.replacingOccurrences(of: " ", with: "")
         
         return strText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
     }
    
     func trimmingString() -> String {
       return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
 
