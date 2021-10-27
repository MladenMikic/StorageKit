//
//  CodableFileStorageTests.swift
//  StorageKitTests
//
//  Created by Mladen Mikic on 26.10.2021..
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import XCTest
@testable import StorageKit

class CodableFileStorageTests: XCTestCase {


    func testCodableFileStorageInit() throws {
        let fileStorage = try FileStorage.withUserDirectory()
        let codableFileStorage = CodableFileStorage(storage: fileStorage)
        XCTAssertNotNil(fileStorage)
        XCTAssertNotNil(codableFileStorage)
    }

}
