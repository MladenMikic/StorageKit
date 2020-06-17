//
//  AsynchronousTest.swift
//  LocalDataStorageOSmacTests
//
//  Created by Mladen Mikic on 25/02/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import XCTest
@testable import StorageKit

class AsynchronousTest: MockDataTestCase {
    
    func testAsynRead() {
        guard let cStorage = self.codableLocalStorage else { return }
        guard let event = self.event1 else { return }
        
        cStorage.save(event, for: event.name) { (result) in
            switch result {
            case .success(let event2):
                XCTAssertEqual(event, event2)
            case .failure(let error):
                 print(error)
            }
           
        }
    }
    
    func testAsynWrite() {
        guard let cStorage = self.codableLocalStorage else { return }
        guard let event = self.event1 else { return }
        
//        cStorage.fetch(for: event.name) { (result) in
//            switch result {
//            case .success(let event2):
//                XCTAssertEqual(event, event2)
//            case .failure(let error):
//                 print(error)
//            }
//        }
//        https://stackoverflow.com/questions/38999102/generics-in-swift-generic-parameter-t-could-not-be-inferred

        
    }
}
