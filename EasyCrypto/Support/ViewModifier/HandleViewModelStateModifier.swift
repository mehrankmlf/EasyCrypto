//
//  HandleViewModelStateModifier.swift
//  EasyCrypto
//
//  Created by Kamalifard, Mehran | TDD on 2024/04/15.
//

import SwiftUI

struct HandleViewModelStateModifier: ViewModifier {

    @ObservedObject var viewModel: DefaultViewModel
  
    @Binding var isLoading: Bool
    @Binding var alertMessage: String
    @Binding var presentAlert: Bool

    func body(content: Content) -> some View {
        content
            .onReceive(viewModel.loadingState.receive(on: DispatchQueue.main)) { state in
                switch state {
                case .loadStart:
                    isLoading = true
                case .dismissAlert:
                    isLoading = false
                    alertMessage = ""
                    presentAlert = false
                case .emptyStateHandler(let message):
                    isLoading = false
                    alertMessage = message
                    presentAlert = true
                }
            }
    }
}
