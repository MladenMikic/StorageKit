//
//  LocalDataStorageTest.swift
//  LocalDataStorageOSmacTests
//
//  Created by Mladen Mikic on 24/02/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import XCTest
@testable import StorageKit

class SynchronousTests: MockDataTestCase {

    func testSimpleReadWrite() {
        
        guard let codableLocalStorage = self.codableLocalStorage else { return }
        guard let event = self.event1 else { return }
        
        do
        {
            try codableLocalStorage.save(event, for: event.name)
            self.cached = try codableLocalStorage.fetch(for: event.name)
        }
        catch
        {
            print("\ntestMultipleReadWrite CATCH.\n")
        }
        
        print("\n\n\(cached.emotions)\n\n")
       
        XCTAssertNotNil(cached)
        XCTAssertEqual(cached!.emotions.count, 3)
    }
    
    
    func testMultipleReadWrite() {
        
        // Overwritting data is possible.
        
        guard let codableLocalStorage = self.codableLocalStorage else { return }
        
        var cached1: Event!
        var cached2: Event!
        var cached3: Event!
        
        var testEvent = Event(emotions: ["Happy", "Sad", "Angry"])
        testEvent.name = Events.test2.rawValue
        
        do
        {
            try codableLocalStorage.save(testEvent, for: testEvent.name)
            cached1 = try codableLocalStorage.fetch(for: testEvent.name)
            
            XCTAssertEqual(testEvent, cached1)
            
            testEvent.name = Events.test1.rawValue
            
            try codableLocalStorage.save(testEvent, for: testEvent.name)
            cached2 = try codableLocalStorage.fetch(for: testEvent.name)
            
            XCTAssertEqual(testEvent, cached2)
            
            testEvent.name = Events.mock1.rawValue
            
            cached3 = try codableLocalStorage.fetch(for: testEvent.name)
            
            XCTAssertNil(cached3)
            
        } catch{
            print("\ntestMultipleReadWrite CATCH.\n")
        }
        
        
        
    }

}
