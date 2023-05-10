//
//  CustomAlert.swift
//  CustomAlertInSwiftUI
//
//  Created by Mehran on 11/22/1401 AP.
//

import SwiftUI

enum AlertAction {
    case ok
    case cancel
    case others
}

struct AlertView: View {

    @Binding var shown: Bool
    @Binding var closureA: AlertAction?
    var isSuccess: Bool
    var message: String

    var body: some View {
        VStack {

    Image(isSuccess ? "check":"remove")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Spacer()
            Text(message).foregroundColor(Color.white)
            Spacer()
            Divider()
            HStack {
                Button("Close") {
                    closureA = .cancel
                    shown.toggle()
                }.frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                .foregroundColor(.white)
                Button("Ok") {
                    closureA = .ok
                    shown.toggle()
                }.frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                .foregroundColor(.white)
            }
        }.frame(width: UIScreen.main.bounds.width-50, height: 200)

        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
        .clipped()

    }
}

struct CustomAlert_Previews: PreviewProvider {

    static var previews: some View {
        AlertView(shown: .constant(false), closureA: .constant(.others), isSuccess: false, message: .empty)
    }
}
