//
//  StorageKitTests.swift
//  StorageKitTests
//
//  Created by Mladen Mikic on 14/06/2020.
//  Copyright © 2020 Mladen Mikic. All rights reserved.
//

import XCTest
@testable import StorageKit

class StorageKitTests: XCTestCase {

    func testUserDefaults() throws {
        Storage.Defaults.set(10.0, forKey: "someFloat")
        XCTAssertEqual(Storage.Defaults.float(forKey: "someFloat"), 10.0)
    }

}
