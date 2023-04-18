//
//  CoreDataPublisher.swift
//  EasyCrypto
//
//  Created by Mehran on 1/4/1402 AP.
//

import Foundation
import Combine
import CoreData

struct CoreDataPublisher<T>: Publisher where T: NSManagedObject, T: Codable {
    
    typealias Output = [T]
    typealias Failure = NSError
    
    private let decoder: JSONDecoder
    private let data: Data
    
    init(decoder: JSONDecoder, data: Data) {
        self.decoder = decoder
        self.data = data
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, decoder: decoder, data: data)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataPublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private var decoder: JSONDecoder
        private var data: Data

        init(subscriber: S, decoder: JSONDecoder, data: Data) {
            self.subscriber = subscriber
            self.decoder = decoder
            self.data = data
        }
    }
}

extension CoreDataPublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }
        do {
            demand -= 1
            let items = try decoder.decode([T].self, from: data)
            demand += subscriber.receive(items)
        } catch {
            subscriber.receive(completion: .failure(error as NSError))
        }
    }
}

extension CoreDataPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
