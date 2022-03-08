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
    
    private let homeDirFileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
    
    public static let standard: UserDefaults = UserDefaults.standard
    public static var shared = Storage()
    
    /// The default value is URLCache.shared
    public var preferredURLCache: URLCache
    
    /// Total device disk space.
    public private(set) var totalDiskSize: Capacity
    
    public var usedDiskSize: Capacity { totalDiskSize - availableDiskSize }
    
    /// Total available device disk space.
    public var availableDiskSize: Capacity {
        var result = Capacity.empty()
        do {
            let values = try homeDirFileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            if let availableCapacity = values.volumeAvailableCapacity {
                result = Capacity(bytes: availableCapacity)
            } else {
                // TODO: Handle error. It is not a critical error.
                self.log(message: "availableDiskSize is unavailable")
            }
        } catch let error {
            // TODO: Handle error. It is not a critical error.
            self.log(message: "Error retrieving availableDiskSize: \(error)")
        }
        return result
    }
    
    lazy var byteCountFormatter: ByteCountFormatter = {
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

        var result = Capacity.empty()
        
        do {
            let values = try homeDirFileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            if let capacity = values.volumeTotalCapacity {
                result = Capacity(bytes: capacity)
            } else {
                // TODO: Handle error. It is not a critical error.
                if Storage.allowsLogging {
                    STLogger.shared.log(message: "totalDiskSize is unavailable")
                }
            }
        } catch let error {
            if Storage.allowsLogging {
                STLogger.shared.log(message: "Error retrieving totalDiskSize: \(error.localizedDescription)")
            }
            // TODO: Handle error. It is not a critical error.
        }
        
        self.totalDiskSize = result
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
    
    public func logDiskUtility() {
       
        let storageValues =
        """
            totalDiskSize: \t\t\(Storage.shared.totalDiskSize.roundedGBs) GB
            availableDiskSize: \t\(Storage.shared.availableDiskSize.roundedGBs) GB
            usedDiskSize: \t\t\(Storage.shared.usedDiskSize.roundedGBs) GB
        """
        self.log(message: storageValues)
    }

}



