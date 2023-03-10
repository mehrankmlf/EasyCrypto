//
//  Color.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

extension Color {
    static let darkBlue  = Color(Color.Key.darkBlue.rawValue)
    static let lightBlue  = Color(Color.Key.lightBlue.rawValue)
    static let lightGreen = Color(Color.Key.lightGreen.rawValue)
    
    enum Key: String {
        case darkBlue = "DarkGray"
        case lightBlue = "LightBLue"
        case lightGreen = "LightGreen"
    }
}

