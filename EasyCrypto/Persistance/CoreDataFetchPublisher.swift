//
//  CoreDataFetchPublisher.swift
//  EasyCrypto
//
//  Created by Mehran on 1/5/1402 AP.
//

import Combine
import CoreData

struct CoreDataFetchResultsPublisher<T>: Publisher where T: NSManagedObject {
    typealias Output = [T]
    typealias Failure = NSError

    private let request: NSFetchRequest<T>
    private let context: NSManagedObjectContext

    init(request: NSFetchRequest<T>, context: NSManagedObjectContext) {
        self.request = request
        self.context = context
    }

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, request: request)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataFetchResultsPublisher {
    class Subscription<S> where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private var request: NSFetchRequest<T>
        private var context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, request: NSFetchRequest<T>) {
            self.subscriber = subscriber
            self.context = context
            self.request = request
        }
    }
}

extension CoreDataFetchResultsPublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }
        do {
            demand -= 1
            let items = try context.fetch(request)
            demand += subscriber.receive(items)
        } catch {
            subscriber.receive(completion: .failure(error as NSError))
        }
    }
}

extension CoreDataFetchResultsPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
