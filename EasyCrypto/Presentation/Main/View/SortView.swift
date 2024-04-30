//
//  SortView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct SortView: View {

    @ObservedObject var viewModel: MainViewModel
  
    @State var viewState: Bool = false

    var body: some View {
        HStack {
            Button {
                if !viewState {
                    if viewModel.rankSort == .rankASC {
                        viewModel.rankSort = .rankDSC
                    } else {
                        viewModel.rankSort = .rankASC
                    }
                    self.viewModel.sortList(type: viewModel.rankSort)
                }
            } label: {
                Rectangle()
                    .frame(width: 140.0, height: 30.0)
                    .foregroundColor(Color.white.opacity(0.1))
                    .cornerRadius(5.0)
                    .overlay {
                        Text(Constants.PlaceHolder.marketCapRank)
                            .foregroundColor(Color.white)
                            .font(FontManager.body)
                    }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
