//
//  String + Extension.swift
//  DrinkApp
//
//  Created by Mehran on 5/27/1401 AP.
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
    
    func isValidEmail() -> Bool {
         let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
         return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
     }
    
    func isValidPhoneNumber() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "09(1[0-9]|3[1-9]|2[1-9])-?[0-9]{3}-?[0-9]{4}", options: [])
             return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.utf8.count)) != nil
        } catch { return false }
    }
}
 
