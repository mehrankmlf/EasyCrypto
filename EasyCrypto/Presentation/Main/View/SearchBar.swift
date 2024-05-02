//
//  SearchBar.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct SearchBar: View {

    @State var isLoading: Bool
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        content
    }

    private var content: some View {
        ZStack(alignment: .leading) {
            HStack {
                TextField("", text: $text)
                    .background(Color.clear)
                    .foregroundColor(.white)
                    .font(FontManager.headLine_2)
                    .placeHolder(Text(Constants.PlaceHolder.searchCoins).font(FontManager.headLine_2)
                        .foregroundColor(.white.opacity(0.3)), show: text.isEmpty)
                    .onTapGesture(perform: {
                        isEditing = true
                    })
                if !text.isEmpty {
                    if isLoading {
                        Button(action: {
                            text = .empty
                        }, label: {
                            ActivityIndicator(style: .medium, animate: .constant(true))
                                .configure {
                                    $0.color = .black
                                }
                        })
                        .frame(width: 35, height: 35)
                    } else {
                        Button(action: {
                            text = .empty
                            isEditing = false
                            dismissKeyboard()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                        }).frame(width: 35, height: 35)
                    }
                }
            }.padding(.horizontal)
                .frame(height: 40.0)
        }
    }
}

struct SearchMarketCellView: View {

    var model: Coin

    var body: some View {
        HStack {
            ImageDownloaderView(withURL: model.safeImageURL())
                .frame(width: 25.0, height: 25.0)

            Text(model.name.orWhenNilOrEmpty(.empty))
                .foregroundColor(Color.black)
                .font(FontManager.body)
            Text("(\(model.symbol.orWhenNilOrEmpty(.empty))")
                .foregroundColor(Color.black)
                .font(FontManager.body)
            Spacer()
            Text(model.marketCapRank != nil ? "#" + String(model.marketCapRank ?? 0) : .empty)
                .foregroundColor(Color.black)
                .font(FontManager.body)
        }
        .padding(.vertical, 5)
    }
}
