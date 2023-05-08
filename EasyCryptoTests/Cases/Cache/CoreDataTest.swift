//
//  CoreDataTest.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/8/23.
//

import XCTest
import CoreData
@testable import EasyCrypto

class CoreDataTest: CacheTest {
    
    let sut: CoreDataManagerProtocol!

    override func setUp() {
        sut = DummyTarget()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
