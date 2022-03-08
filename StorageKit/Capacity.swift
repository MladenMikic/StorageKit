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
    
    public var bytes: Double
    public var roundedBytes: Int
    public var MBs: Float { Float(bytes / 1_024 / 1_024) }
    public var GBs: Float { Float(bytes / 1_024 / 1_024 / 1_024) }
    public var roundedMBs: Int { roundedBytes / 1_024 / 1_024  }
    public var roundedGBs: Int { roundedBytes / 1_024 / 1_024 / 1_024 }
    /// Rounded byte value in MBs.
    public var titleInMBs: String { "\(roundedMBs) MB" }
    /// Rounded byte value in GBs.
    public var titleInGBs: String { "\(roundedGBs) GB" }
    
    // MARK: - Init.
    
    public init(bytes: Double) {
        self.roundedBytes = Int(bytes)
        self.bytes = bytes
    }
    
    public init(bytes: Int) {
        self.roundedBytes = bytes
        self.bytes = Double(bytes)
    }
    
    static func empty() -> Capacity { Self.init(bytes: 0) }
    
    public static func - (left: Capacity, right: Capacity) -> Capacity {
        return Capacity(bytes: left.bytes - right.bytes)
    }
}
