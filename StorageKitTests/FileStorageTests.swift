//
//  FileStorageTests.swift
//  StorageKitTests
//
//  Created by Mladen Mikic on 26.10.2021..
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import XCTest
@testable import StorageKit

class FileStorageTests: XCTestCase {

    func testFileStorageUserDirectoryInit() throws {
        let fileStorage = try FileStorage.withUserDirectory()
        XCTAssertNotNil(fileStorage)
    }

}
