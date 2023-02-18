//
//  CoinDetailCoordinator.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import SwiftUI
import Combine

struct CoinDetailCoordinator: Coordinator, DependencyAssemblerInjector {

    @StateObject var viewModel : CoinDetailViewModel
    @State var activeRoute: Destination? = Destination(route: .first(url: ""))
    @State var transition: Transition?
    
    let subscriber = Subscriber()

    var body: some View {
        coinDetailView
            .route(to: $activeRoute)
            .navigation()
            .onAppear {
                self.coinDetailView.viewModel.navigateSubject
                    .sink { route in
                        activeRoute = Destination(route: route)
                    }.store(in: subscriber)
            }
    }
    
    var coinDetailView: CoinDetailView {
        return CoinDetailView(viewModel: viewModel)
    }
}

extension CoinDetailCoordinator {
    struct Destination: RouteDestination {
        
        var route: CoinDetailView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .first(let data):
                print(data)
            }
        }
        
        var transition: Transition {
            switch route {
            case .first: return .url
            }
        }
    }
}
