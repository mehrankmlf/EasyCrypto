//
//  Router.swift
//  CoordinatorSwiftUI
//
//  Created by MOUAD BENJRINIJA on 5/10/2022.
//

import SwiftUI

// types of transitions
enum Transition {
  case push
  case sheet
}

// Manages the transitions between child routes of a certain view
struct Router<Destination: RouteDestination>: ViewModifier {
  @Binding var destination: Destination?
  @State var isLinkActive = false
  @State var isSheetActive = false

  func body(content: Content) -> some View {
    ZStack {
      NavigationLink(
        destination: destinationView,
        isActive: $isLinkActive, label: {})
      content
    }.sheet(isPresented: $isSheetActive, content: { destinationView })
     .onChange(of: destination, perform: {_ in routeChanged()})
     .onChange(of: isLinkActive, perform: {_ in routeDismissed()})
     .onChange(of: isSheetActive, perform: {_ in routeDismissed()})
  }

  var destinationView: some View {
    destination?.content
  }

  func routeDismissed() {
    if !isLinkActive && !isSheetActive {
      destination = nil
    }
  }

  func routeChanged() {
    guard let destination = destination else { return }
    isSheetActive = destination.transition == .sheet
    isLinkActive = destination.transition == .push
  }
}

struct Navigator: ViewModifier {
  func body(content: Content) -> some View {
    NavigationView {
      content
    }
  }
}

// Convenience modifiers
extension View {
  func route<Destination: RouteDestination>(to destination: Binding<Destination?>) -> some View {
    modifier(Router(destination: destination))
  }

  func navigation() -> some View {
    modifier(Navigator())
  }
}
