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
            Color.darkBlue
                .ignoresSafeArea()
            VStack {
                HeaderView()
                SortView()
                CryptoCellView()
                Spacer()
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
                .fontStyle(FontManager.title)
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

struct SortView: View {
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Rectangle()
                    .frame(width: 130.0, height: 30.0)
                    .foregroundColor(Color.white.opacity(0.1))
                    .cornerRadius(5.0)
                    .overlay {
                        Text("Highest Holding")
                            .fontStyle(FontManager.body)
                    }
            }
            Spacer()
            Button {
                
            } label: {
                Rectangle()
                    .frame(width: 90.0, height: 30.0)
                    .foregroundColor(Color.white.opacity(0.1))
                    .cornerRadius(5.0)
                    .overlay {
                        Text("24 Hours")
                            .fontStyle(FontManager.body)
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct CryptoCellView: View {
    
    var body: some View {
        HStack {
            Image("bitcoin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30.0, height: 30.0)
            VStack(spacing: 5) {
                Text("Bitcoin")
                    .fontStyle(FontManager.body)
                Text("2 TLCV")
                    .foregroundColor(Color.gray)
                    .fontStyle(FontManager.bodyLight)
            }.padding(.leading, 5)
            Spacer()
            VStack(spacing: 5) {
                Text("23456")
                    .fontStyle(FontManager.body)
                Text("+ 74.9")
                    .foregroundColor(Color.green)
                    .fontStyle(FontManager.body)
            }
        }
        .padding()
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
