//
//  Schedular.swift
//  SappProject
//
//  Created by Mehran Kamalifard on 12/6/22.
//

import Combine
import Foundation

final class Scheduler {
    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main
    
    static let mainThread = DispatchQueue.main
}
