//
//  SpinnerViewIndicator.swift
//  DrinkApp
//
//  Created by Mehran Kamalifard on 8/22/22.
//

import SwiftUI

struct SpinnerViewIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<SpinnerViewIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<SpinnerViewIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
