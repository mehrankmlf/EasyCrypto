//
//  Coordinator.swift
//  CoordinatorSwiftUI
//
//  Created by MOUAD BENJRINIJA on 5/10/2022.
//

import SwiftUI

protocol DestinationProtocol: Equatable {
  associatedtype Destination: View
  var content: Destination { get }
  var transition: Transition { get }
}

protocol CoordinatorProtocol: View {
  associatedtype MainContent: Coordinatable
  associatedtype Destination: DestinationProtocol
  var mainView: MainContent { get }
  var activeRoute: Destination? { get }
}

extension CoordinatorProtocol {
    var url: String? {
        return nil
    }
}

