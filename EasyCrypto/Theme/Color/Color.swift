//
//  Color.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

extension Color {
    static let darkBlue  = Color(Color.KeyType.darkBlue.rawValue)
    static let lightBlue  = Color(Color.KeyType.lightBlue.rawValue)
    static let lightGreen = Color(Color.KeyType.lightGreen.rawValue)

    enum KeyType: String {
        case darkBlue = "DarkGray"
        case lightBlue = "LightBLue"
        case lightGreen = "LightGreen"
    }
}
