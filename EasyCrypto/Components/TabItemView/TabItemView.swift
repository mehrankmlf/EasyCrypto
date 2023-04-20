//
//  TabItemView.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 4/17/23.
//

import SwiftUI

struct TabItemView: View {
    @Binding var index: Int
    var titles = ["Coins", "Whishlists"]
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(titles.indices) {id in
                        let title = Text(titles[id]).id(id)
                            .font(FontManager.headLine_2)
                            .onTapGesture {
                                withAnimation {
                                    index = id
                                }
                            }
                        if self.index == id {
                            title.foregroundColor(.white)
                        } else {
                            title.foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .font(.title)
                    .padding(.horizontal, 5)
                }
                .padding(.leading, 20)
            }.onChange(of: index) { value in
                withAnimation {
                 proxy.scrollTo(value, anchor: UnitPoint(x: UnitPoint.leading.x + leftOffset, y: UnitPoint.leading.y))
                }
            }.animation(.easeInOut)
        }
    }
    private let leftOffset: CGFloat = 0.1
}
