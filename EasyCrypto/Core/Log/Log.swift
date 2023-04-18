//
//  Log.swift
//  EasyCrypto
//
//  Created by Mehran on 1/6/1402 AP.
//

import Foundation

func log(_ text: String) {
    let thread = Thread.isMainThread ? "main thread" : "other thread"
    print("[\(thread)] \(text)")
}
