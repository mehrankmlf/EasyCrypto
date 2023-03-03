//
//  AppDependencyContainer.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import Foundation

protocol AwesomeDICProtocol {
  func register<Service>(type: Service.Type, component: Any)
  func resolve<Service>(type: Service.Type) -> Service?
}

final class DIContainer: AwesomeDICProtocol {
    
  static let shared = DIContainer()

  private init() {}

  var services: [String: Any] = [:]

    func register<Service>(type: Service.Type, component service: Any) {
      services["\(type)"] = service
  }

  func resolve<Service>(type: Service.Type) -> Service? {
    return services["\(type)"] as? Service
  }
}
