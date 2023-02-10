//
//  SpinnerViewHandler.swift
//  DrinkApp
//
//  Created by Mehran Kamalifard on 8/22/22.
//

import SwiftUI

struct SpinnerViewHandler: View {
    
    let geoSize: CGSize
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                SpinnerViewIndicator(isAnimating: $isShowing, style: .medium)
            }
            .frame(width: geoSize.width,
                   height: geoSize.height)
            .background(Color.black.opacity(0.5))
            .opacity(self.isShowing ? 1 : 0)

        }
    }
}
