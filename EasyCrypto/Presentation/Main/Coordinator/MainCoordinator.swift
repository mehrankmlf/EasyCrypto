//
//  MainCoordinator.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import SwiftUI
import Combine

struct MainCoordinator: Coordinator, DependencyAssemblerInjector {

    @StateObject var viewModel : MainViewModel
    @State var activeRoute: Destination? = Destination(route: .first(item: MarketsPrice()))
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
    
    var mainView: MainView {
        return MainView(viewModel: viewModel)
    }
}

extension MainCoordinator {
    struct Destination: RouteDestination, DependencyAssemblerInjector {
        
        var route: MainView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .first(let data):
                DetailView(item: data)
            case .second(let data):
                CoinDetailView(id: data, viewModel: self.dependencyAssembler.makeCoinDetailViewModel())
            }
        }
        
        var transition: Transition {
            switch route {
            case .first: return .push
            case .second: return .push
            }
        }
    }
}


