//
//  DetailView.swift
//  EasyCrypto
//
//  Created by Mehran on 11/19/1401 AP.
//

import SwiftUI

struct DetailView: View {
    
    var item: MarketsPrice?
    
    var body: some View {
        Text(item?.id ?? "")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
