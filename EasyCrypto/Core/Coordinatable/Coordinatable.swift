//
//  Coordinatable.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import SwiftUI

// implemented by routes enum inside each view
protocol Routing: Equatable {}

// implemented by the view that has routes
protocol Coordinatable: View {
  associatedtype Route: Routing
}
