//
//  BaseAPIDebuger.swift
//  Amadeus
//
//  Created by Mehran on 6/4/1401 AP.
//

import Foundation

struct BaseAPIDebuger {
    
    func log(request: URLRequest?, error : Error?) {

        debugPrint("", terminator: "\n\n")
        debugPrint("--------------- Request Log Starts ---------------", terminator: "\n\n")
        if let request = request, let allHTTPHeaderFields = request.allHTTPHeaderFields {
            if let url = request.url {
                debugPrint("Request URL - \(String(describing: url))", terminator: "\n")
            }
            if let body = request.httpBody, let json = body.printableJSON {
                debugPrint("Request Body -", terminator: "\n")
                debugPrint(json, terminator: "\n")
            } else {
                debugPrint("", terminator: "\n")
            }
            debugPrint("--------------- Request Headers ---------------", terminator: "\n\n")
            for (headerKey, headerValue) in allHTTPHeaderFields {
                debugPrint("\(headerKey) - \(headerValue)", terminator: "\n")
            }
        }
        debugPrint("", terminator: "\n\n")
        debugPrint("--------------- Response Headers ---------------", terminator: "\n\n")
        
        if let error = error, let errorFound = error as NSError? {
            debugPrint("--------------- Error ---------------", terminator: "\n\n")
            debugPrint("Error Code - \(errorFound.code)", terminator: "\n")
            debugPrint("Error Domain - \(errorFound.domain)", terminator: "\n")
            debugPrint("Error UserInfo - \(errorFound.userInfo)", terminator: "\n\n")
        }
        debugPrint("--------------- Request Log Ends ---------------", terminator: "\n\n")
    }
}

extension Data {
    var printableJSON: NSString? {
        var jsonStr: NSString?
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []) {
            if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
                jsonStr = NSString(data: data,
                                   encoding: String.Encoding.utf8.rawValue)
            }
        }
        return jsonStr
    }
}
