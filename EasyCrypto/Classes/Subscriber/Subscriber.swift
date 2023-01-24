//
//  Subscriber.swift
//  SappProject
//
//  Created by Mehran Kamalifard on 11/30/22.
//

import Combine

final class Subscriber {
    
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in subscriber: Subscriber) {
        subscriber.subscriptions.insert(self)
    }
}
