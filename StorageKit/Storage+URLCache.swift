//
//  Storage+URLCache.swift
//  StorageKit
//
//  Created by Mladen Mikic on 22.10.2021.
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import Foundation


public extension Storage {
    
    /// This size, measured in bytes, indicates the current  usage of the on-disk cache.
    var currentURLCacheDiskUsageInBytes: Int {
        return self.preferredURLCache.currentDiskUsage
    }
    
    var currentURLCacheDiskUsageReadable: String {
        return self.byteCountFormatter.string(fromByteCount: Int64(self.currentURLCacheDiskUsageInBytes))
    }
    
    var isSharedURLCacheUsed: Bool { self.preferredURLCache == URLCache.shared }

}
