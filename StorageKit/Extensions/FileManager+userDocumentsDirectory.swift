//
//  FileManager+userDocumentsDirectory.swift
//  StorageKit
//
//  Created by Mladen Mikic on 08.12.2021..
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import Foundation

public extension FileManager {
    /// for: .documentDirectory
    /// in: .userDomainMask
    static var documentsDirectory: URL? { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first }
}
