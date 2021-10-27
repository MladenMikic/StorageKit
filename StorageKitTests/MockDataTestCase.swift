//
//  DataModel.swift
//  LocalDataStorageOSmacTests
//
//  Created by Mladen Mikic on 25/02/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import XCTest
@testable import StorageKit

public struct Event: Codable {
    var name: String!
    let emotions: [String]
}

extension Event: Equatable
{
    public static func == (lhs: Self, rhs: Self) -> Bool
    {
        return (lhs.name == rhs.name) && (lhs.emotions == rhs.emotions)
    }
    
}

public enum Events: String {
    case test1 = "test1"
    case test2 = "test2"
    case mock1 = "mock1"
}

open class MockDataTestCase: XCTestCase {
    
    public var event1: Event!
    public var localStorage1: FileStorage!
    public var cached: Event!
    public var codableLocalStorage: CodableFileStorage!
       
    override public func setUp() {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        self.localStorage1 = FileStorage(path: path)
        self.codableLocalStorage = CodableFileStorage(storage: self.localStorage1)
           
        self.event1 = Event(emotions: ["Happy", "Sad", "Angry"])
        self.event1.name = Events.test1.rawValue
    }

    override public func tearDown() {
        self.localStorage1 = nil
        self.codableLocalStorage = nil
        self.event1 = nil
    }
    
}
