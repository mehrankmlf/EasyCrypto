//
//  Coordinator.swift
//  CoordinatorSwiftUI
//
//  Created by Mehran on 11/15/1401 AP.
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
