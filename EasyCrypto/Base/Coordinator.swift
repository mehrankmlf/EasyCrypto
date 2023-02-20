//
//  Coordinator.swift
//  CoordinatorSwiftUI
//
//  Created by MOUAD BENJRINIJA on 5/10/2022.
//

import SwiftUI

// implemented by the route factory
// it manages view creation and transition
protocol RouteDestination: Equatable {
  associatedtype Destination: View
  var content: Destination { get }
  var transition: Transition { get }
}

// implemented by the wrapper view which acts as a coordinator
protocol Coordinator: View {
  associatedtype MainContent: Coordinatable
  associatedtype Destination: RouteDestination
  var mainView: MainContent { get }
  var activeRoute: Destination? { get }
  var url: String? { get }
}

extension Coordinator {
    var url: String? {
        return nil
    }
}

