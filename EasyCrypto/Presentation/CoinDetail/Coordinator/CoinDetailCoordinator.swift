//
//  CoinDetailCoordinator.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import SwiftUI
import Combine

struct CoinDetailCoordinator: CoordinatorProtocol {

    @ObservedObject var viewModel: CoinDetailViewModel

    @State var activeRoute: Destination? = Destination(route: .first(url: nil))
    @State var transition: Transition?

    let id: String

    let subscriber = Cancelable()

    var body: some View {
        mainView
            .route(to: $activeRoute)
            .navigation()
            .onAppear {
                self.mainView.viewModel.navigateSubject
                    .sink { route in
                        activeRoute = Destination(route: route)
                    }.store(in: subscriber)
            }
    }

    var mainView: CoinDetailView {
        return CoinDetailView(id: id, viewModel: viewModel)
    }
}

extension CoinDetailCoordinator {
    struct Destination: DestinationProtocol {

        var route: CoinDetailView.Routes

        @ViewBuilder
        var content: some View {
            switch route {
            case .first(let url):
                if let url = url {
                    SafariView(url: url)
                }
            }
        }

        var transition: Transition {
            switch route {
            case .first: return .url
            }
        }
    }
}
