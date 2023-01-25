//
//  MainView.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            Color.darkBLue
                .ignoresSafeArea()
            VStack {
                HeaderView()
            }
        }
    }
}

struct HeaderView: View {
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(Assets.magnifier)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
            }
            Spacer()
            Text(Constants.mainTitle)
                .fontStyle(FontManager.body)
            Spacer()
            Button {
                
            } label: {
                Image(Assets.sort)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
