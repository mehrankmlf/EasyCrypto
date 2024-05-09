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
    private let leftOffset: CGFloat = 0.1

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(titles.indices) { id in
                        TabTitleView(title: titles[id], isSelected: index == id)
                            .onTapGesture {
                                withAnimation {
                                    index = id
                                }
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
            .onChange(of: index) { newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .leading)
                }
            }
            .animation(.easeInOut)
        }
    }
}

struct TabTitleView: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(FontManager.headLine_2)
            .font(.title)
            .foregroundColor(isSelected ? .white : Color.white.opacity(0.5))
    }
}
