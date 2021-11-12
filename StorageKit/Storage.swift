//
//  Storage.swift
//  StorageKit
//
//  Created by Mladen Mikic on 14/06/2020.
//

import Foundation


public class Storage: STLoggerProtocol {
 
    // MARK: - STLoggerProtocol.
    static var allowsLogging: Bool = true
    
    public static let standard: UserDefaults = UserDefaults.standard
    public static var shared = Storage()
    
    /// The default value is URLCache.shared
    public var preferredURLCache: URLCache
    
    lazy var byteCountFormatter:ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        return formatter
    }()
    
    // MARK: - Init.
    
    private init(preferredURLCache: URLCache = .shared) {
        self.preferredURLCache = preferredURLCache
    }
    
    func save<T: Encodable>(_ value: T, for key: String) {
        self.log(message: "\(self): \(#function): \(#line)")
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileStorage = FileStorage(path: path)
        let codableFileStorage = CodableFileStorage(storage: fileStorage)
        do {
            self.log(message: "\(self): \(#function): Started saving...")
            try codableFileStorage.save(value, for: key)
            self.log(message: "\(self): \(#function): SAVED \n\tin: \(path) \n\tfor key: \(key).")
        } catch let error {
            self.log(message: "\(self): \(#function): FAILED TO SAVE \n\tin: \(path) \n\tfor key: \(key)\n\twith error: \(error)")
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

