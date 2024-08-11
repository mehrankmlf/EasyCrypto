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
        ZStack(alignment: .leading) {
            HStack {
                searchField
                if !text.isEmpty {
                    clearButton
                }
            }
            .padding(.horizontal)
            .frame(height: 40.0)
        }
    }

    private var searchField: some View {
        TextField("", text: $text)
            .background(Color.clear)
            .foregroundColor(.white)
            .font(FontManager.headLine_2)
            .placeHolder(
                Text(Constants.PlaceHolder.searchCoins)
                    .font(FontManager.headLine_2)
                    .foregroundColor(.white.opacity(0.3)),
                show: text.isEmpty
            )
            .onTapGesture {
                isEditing = true
            }
    }

    private var clearButton: some View {
        Group {
            if isLoading {
                ActivityIndicatorButton(action: {
                    text = .empty
                })
            } else {
                ClearTextButton(action: {
                    text = .empty
                    isEditing = false
                    dismissKeyboard()
                })
            }
        }
        .frame(width: 35, height: 35)
    }
}

private struct ActivityIndicatorButton: View {
    
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ActivityIndicator(style: .medium, animate: .constant(true))
                .configure {
                    $0.color = .black
                }
        }
    }
}

private struct ClearTextButton: View {
    
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
        }
    }
}

struct SearchMarketCellView: View {

    var model: Coin

    var body: some View {
        HStack {
            ImageDownloaderView(withURL: model.safeImageURL())
                .frame(width: 25.0, height: 25.0)

            VStack(alignment: .leading) {
                Text(model.name.orWhenNilOrEmpty(.empty))
                Text(model.symbol.orWhenNilOrEmpty(.empty))
            }
            .foregroundColor(.black)
            .font(FontManager.body)

            Spacer()

            if let rank = model.marketCapRank {
                Text("#\(rank)")
                    .foregroundColor(.black)
                    .font(FontManager.body)
            }
        }
        .padding(.vertical, 5)
    }
}
