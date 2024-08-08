//
//  DetailViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 1/13/1402 AP.
//

import Foundation

final class DetailViewModel: ObservableObject {

    let title: String = Constants.Title.detailTitle
    private let repository: CacheRepositoryProtocol

    init(repository: CacheRepositoryProtocol = DIContainer.shared.inject(type: CacheRepositoryProtocol.self)!) {
        self.repository = repository
    }

    func addToWishlist(_ data: MarketsPrice) {
        do {
            try repository.save(data)
        } catch {
            // Handle error, e.g., log it or show an alert
            print("Error saving to wishlist: \(error.localizedDescription)")
        }
    }

    func deleteFromWishlist(_ data: MarketsPrice) {
        guard let name = data.name else { return }
        do {
            try repository.deleteByID(name)
        } catch {
            // Handle error, e.g., log it or show an alert
            print("Error deleting from wishlist: \(error.localizedDescription)")
        }
    }

    func checkIfItemExist(_ data: MarketsPrice) -> Bool {
        guard let name = data.name else {return false}
        if (repository.fetchItem(name)) != nil {
            return true
        }
        return false
    }
}
