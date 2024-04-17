//
//  View + Extension.swift
//  EasyCrypto
//
//  Created by Mehran on 5/31/1401 AP.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func handleViewModelState(viewModel: DefaultViewModel,
                              isLoading: Binding<Bool>,
                              alertMessage: Binding<String>,
                              presentAlert: Binding<Bool>) -> some View {
        self.modifier(HandleViewModelStateModifier(viewModel: viewModel,
                                                   isLoading: isLoading,
                                                   alertMessage: alertMessage,
                                                   presentAlert: presentAlert))
    }
}
