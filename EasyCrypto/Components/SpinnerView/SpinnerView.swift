//
//  SpinnerView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/24/1401 AP.
//

import SwiftUI

struct SpinnerView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    var geoSize: CGSize
    var content: () -> Content

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                VStack {
                    if !self.text.isEmpty {
                        SpinnerViewIndicator(isAnimating: $isShowing, style: .medium)
                            .padding(.top)
                        Text(self.text)
                            .padding([.leading, .trailing, .bottom])
                    } else {
                        SpinnerViewIndicator(isAnimating: $isShowing, style: .medium)
                    }
                }
                .frame(minWidth: 78,
                       idealWidth: nil,
                       maxWidth: nil,
                       minHeight: 78,
                       idealHeight: nil,
                       maxHeight: nil,
                       alignment: .center)
                .background(Color.white.opacity(0.5))
                .foregroundColor(Color.primary)
                .cornerRadius(6)
                .opacity(self.isShowing ? 1 : 0)
            }
            .frame(width: geoSize.width)
        }
    }
}
