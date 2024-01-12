//
//  AppDependencyContainer.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 2/16/23.
//

import Foundation

protocol DIContainerProtocol {
  func register<Service>(type: Service.Type, component: Any)
  func inject<Service>(type: Service.Type) -> Service?
}

final class DIContainer: DIContainerProtocol {

  static let shared = DIContainer()

  private init() {}

  var services: [String: Any] = [:]

    func register<Service>(type: Service.Type, component service: Any) {
      services["\(type)"] = service
  }

  func inject<Service>(type: Service.Type) -> Service? {
    return services["\(type)"] as? Service
  }
}
