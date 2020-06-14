//
//  Storage.swift
//  StorageKit
//
//  Created by Mladen Mikic on 14/06/2020.
//

import Foundation


public class Storage {
 
    public static let standard: UserDefaults = UserDefaults.standard
    
}

public extension UserDefaults {
    public func increment(value: Int, forKey key: String) {
        var count = Storage.standard.integer(forKey: key)
        count += value
        Storage.standard.set(value, forKey: key)
    }
    
    public func inc1(forKey key: String) {
        self.increment(value: 1, forKey: key)
    }
}

