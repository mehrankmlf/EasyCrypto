//
//  SortView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct SortView: View {

    @ObservedObject var viewModel: MainViewModel
    @State var isLoading: Bool = false

    var body: some View {
        HStack {
            sortButton
            Spacer()
        }
        .padding(.horizontal)
    }

    private var sortButton: some View {
        Button(action: toggleSortOrder) {
            Rectangle()
                .frame(width: 140.0, height: 30.0)
                .foregroundColor(Color.white.opacity(0.1))
                .cornerRadius(5.0)
                .overlay {
                    Text(Constants.PlaceHolder.marketCapRank)
                        .foregroundColor(.white)
                        .font(FontManager.body)
                }
        }
    }

    private func toggleSortOrder() {
        guard !isLoading else { return }

        viewModel.rankSort = (viewModel.rankSort == .rankASC) ? .rankDSC : .rankASC
        viewModel.sortList(type: viewModel.rankSort)
    }
}
