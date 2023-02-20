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
        return CoinDetailView(viewModel: viewModel)
    }
    
    var url: String?
}

extension CoinDetailCoordinator {
    struct Destination: RouteDestination {
        
        var route: CoinDetailView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .first(let url):
                SafariView(url: URL(string: url)!)
            }
        }
        
        var transition: Transition {
            switch route {
            case .first: return .url
            }
        }
    }
}
