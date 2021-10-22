//
//  Storage.swift
//  StorageKit
//
//  Created by Mladen Mikic on 14/06/2020.
//

import Foundation


public class Storage {
 
    public static let standard: UserDefaults = UserDefaults.standard
    public static var shared = Storage()
    
    /// The default value is URLCache.shared
    public var preferredURLCache: URLCache
    private init(preferredURLCache: URLCache = .shared) {
        self.preferredURLCache = preferredURLCache
    }
    
    func save<T: Encodable>(_ value: T, for key: String) {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileStorage = FileStorage(path: path)
        let codableFileStorage = CodableFileStorage(storage: fileStorage)
        do {
            try codableFileStorage.save(value, for: key)
            print("\n\nStore saved \(value) SUCCESS.\n\n")
        } catch {
            print("\n\nStore saved \(value) FAILED.\n\n")
        }
    }

}

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

