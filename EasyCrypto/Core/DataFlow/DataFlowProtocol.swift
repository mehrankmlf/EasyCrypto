//
//  DataFlowProtocol.swift
//  EasyCrypto
//
//  Created by Mehran on 11/19/1401 AP.
//

import Foundation

protocol DataFlowProtocol {
    associatedtype InputType
    
    func apply(_ input: InputType)
}
