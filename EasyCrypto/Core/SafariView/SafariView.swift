//
//  SafariView.swift
//  EasyCrypto
//
//  Created by Mehran on 12/17/1401 AP.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        return SFSafariViewController(url: url, configuration: configuration)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
}
