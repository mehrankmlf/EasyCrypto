//
//  CoreDataDeletePublisher.swift
//  EasyCrypto
//
//  Created by Mehran on 1/12/1402 AP.
//

import Combine
import CoreData

struct CoreDataDeleteModelPublisher: Publisher {
    typealias Output = NSBatchDeleteResult
    typealias Failure = NSError
    
    private let request: NSFetchRequest<NSFetchRequestResult>
    private let context: NSManagedObjectContext
    
    init(delete request: NSFetchRequest<NSFetchRequestResult>, context: NSManagedObjectContext) {
        self.request = request
        self.context = context
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, request: request)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataDeleteModelPublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let request: NSFetchRequest<NSFetchRequestResult>
        private var context: NSManagedObjectContext
        
        init(subscriber: S, context: NSManagedObjectContext, request: NSFetchRequest<NSFetchRequestResult>) {
            self.subscriber = subscriber
            self.context = context
            self.request = request
        }
    }
}

extension CoreDataDeleteModelPublisher.Subscription: Subscription  {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }
        
        do {
            demand -= 1
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: self.request)
            batchDeleteRequest.resultType = .resultTypeCount
            
            if let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                demand += subscriber.receive(result)
            }
            else {
                subscriber.receive(completion: .failure(NSError()))
            }
            
        } catch {
            subscriber.receive(completion: .failure(error as NSError))
        }
    }
}

extension CoreDataDeleteModelPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
