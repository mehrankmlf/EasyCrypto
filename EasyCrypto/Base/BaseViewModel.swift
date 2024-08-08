//
//  BaseViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine
import SwiftUI

enum ViewModelStatus: Equatable {
    case loadStart
    case dismissAlert
    case emptyStateHandler(title: String)
}

protocol BaseViewModelEventSource: AnyObject {
    var loadingState: CurrentValueSubject<ViewModelStatus, Never> { get }
}

protocol ViewModelService: AnyObject {
    func call<ReturnType>(callWithIndicator: Bool,
                          argument: AnyPublisher<ReturnType?,
                          APIError>,
                          callback: @escaping (_ data: ReturnType?) -> Void)
}

typealias BaseViewModel = BaseViewModelEventSource & ViewModelService

open class DefaultViewModel: BaseViewModel, ObservableObject {

    var loadingState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    let subscriber = Cancelable()

    func call<ReturnType>(
        callWithIndicator: Bool = true,
        argument: AnyPublisher<ReturnType, APIError>,
        callback: @escaping (_ data: ReturnType) -> Void
    ) {
        if callWithIndicator {
            self.loadingState.send(.loadStart)
        }

        argument
            .subscribe(on: WorkScheduler.backgroundWorkScheduler)
            .receive(on: WorkScheduler.mainScheduler)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.loadingState.send(.dismissAlert)
                        self?.loadingState.send(.emptyStateHandler(title: error.desc))
                    case .finished:
                        self?.loadingState.send(.dismissAlert)
                    }
                },
                receiveValue: { data in
                    callback(data)
                }
            )
            .store(in: subscriber)
    }
}
