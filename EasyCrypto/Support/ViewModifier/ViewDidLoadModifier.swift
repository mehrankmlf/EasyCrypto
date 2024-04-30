//
//  ViewDidLoadModifier.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 5/13/23.
//

import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {

    @State private var viewDidLoad = false
    let action: (() -> Void)?

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

public extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}
