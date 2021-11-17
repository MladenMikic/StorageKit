//
//  Capacity.swift
//  StorageKit
//
//  Created by Mladen Mikic on 17.11.2021.
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import Foundation

// Additional learning & features:
// https://stackoverflow.com/questions/26198073/query-available-ios-disk-space-with-swift
public struct Capacity {
    
    public var bytes: Int
    public var MBs: Int { bytes / 1000000 }
    public var GBs: Int { bytes / 1000000000 }
    
    public init(bytes: Int) {
        self.bytes = bytes
    }
    
    static func empty() -> Capacity { Self.init(bytes: 0) }
    
    public static func - (left: Capacity, right: Capacity) -> Capacity {
        return Capacity(bytes: left.bytes - right.bytes)
    }
}
