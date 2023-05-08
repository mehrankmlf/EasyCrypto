//
//  DetailViewModelTest.swift
//  EasyCryptoTests
//
//  Created by Mehran on 2/7/1402 AP.
//

import XCTest
import Combine
@testable import EasyCrypto

final class DetailViewModelTest: XCTestCase {
    
    private var viewModelToTest: DetailViewModel!

    override func setUp()  {
        viewModelToTest = DetailViewModel()
    }
    
    override func tearDown() {
        viewModelToTest = nil
        super.tearDown()
    }
    
    
}
