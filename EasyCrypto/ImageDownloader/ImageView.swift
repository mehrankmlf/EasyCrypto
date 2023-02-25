//
//  ImageLoader.swift
//  DrinkApp
//
//  Created by Mehran on 5/28/1401 AP.
//

import Combine
import SwiftUI

struct ImageView: View {
    
    @ObservedObject var imageLoader:ImageDownloader

    init(withURL url: String) {
        imageLoader = ImageDownloader(urlString:url)
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: imageLoader.image ?? UIImage() )
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
