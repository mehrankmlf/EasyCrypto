//
//  Navigation + Exetnsion.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import UIKit

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
