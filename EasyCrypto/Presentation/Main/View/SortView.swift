//
//  SortView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI

struct SortView: View {
    
    @State var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            Button {
                if !viewModel.isloading {
                    if (viewModel.rankSort == .rankASC){
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
                        Text("Market Cap Rank")
                            .foregroundColor(Color.white)
                            .font(FontManager.body)
                    }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
