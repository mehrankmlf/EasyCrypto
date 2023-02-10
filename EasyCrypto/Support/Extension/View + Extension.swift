//
//  View + Extension.swift
//  DrinkApp
//
//  Created by Mehran on 5/31/1401 AP.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
