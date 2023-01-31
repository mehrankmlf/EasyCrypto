//
//  FontManager.swift
//  SappProject
//
//  Created by Mehran on 9/11/1401 AP.
//

import Foundation
import SwiftUI

struct FontManager {
    static let title = FontStyle(font: Font.custom(FontType.regular.rawValue,
                                                  size: 18.0),
                                                  weight: .regular,
                                                  foregroundColor: .white)
    static let body = FontStyle(font: Font.custom(FontType.regular.rawValue,
                                                  size: 14.0),
                                                  weight: .regular,
                                                  foregroundColor: .white)
    static let bodyLight = FontStyle(font: Font.custom(FontType.regular.rawValue,
                                                  size: 12.0),
                                                  weight: .regular,
                                                  foregroundColor: .white)
}
