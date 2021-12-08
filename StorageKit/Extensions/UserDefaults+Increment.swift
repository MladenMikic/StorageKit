//
//  UserDefaults+Increment.swift
//  StorageKit
//
//  Created by Mladen Mikic on 08.12.2021.
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import Foundation


public extension UserDefaults {

    func increment(value: Int, forKey key: String) {
        var count = Storage.standard.integer(forKey: key)
        count += value
        Storage.standard.set(value, forKey: key)
    }
    
    func increment(forKey key: String) {
        self.increment(value: 1, forKey: key)
    }
}
