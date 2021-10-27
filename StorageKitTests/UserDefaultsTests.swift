//
//  StorageKitTests.swift
//  StorageKitTests
//
//  Created by Mladen Mikic on 14/06/2020.
//  Copyright © 2020 Mladen Mikic. All rights reserved.
//

import XCTest
@testable import StorageKit

class UserDefaultsTests: XCTestCase {

    func testUserDefaults() throws {
        Storage.standard.set(10.0, forKey: "someFloat")
        XCTAssertEqual(Storage.standard.float(forKey: "someFloat"), 10.0)
    }

}
