//
//  FontTemplateModifier.swift
//  SwiftRorty.iOS
//
//  Created by developersancho on 28.02.2022.
//

import SwiftUI

struct FontViewModifier: ViewModifier {
    let fontStyle: FontStyle
    init(fontStyle: FontStyle) {
        self.fontStyle = fontStyle
    }
    func body(content: Content) -> some View {
        content
            .font(fontStyle.font
                    .weight(fontStyle.weight))
            .lineSpacing(fontStyle.lineSpacing)
            .foregroundColor(fontStyle.foregroundColor)
    }
}

extension View {
    public func fontStyle(_ fontStyle: FontStyle) -> some View {
        modifier(FontViewModifier(fontStyle: fontStyle))
    }
}
