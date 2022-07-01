//
//  Errors.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 06/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

public enum StorageError: Error, LocalizedError {
    case resourcesNotFound
    case resourceNotFound(forKey: String)
    case cantWrite(Error)
    case releasedSelf
    
    public var errorDescription: String? {
        switch self {
            // (DE) Errors.
            case .resourcesNotFound:
                return NSLocalizedString("Several resources could not be found on the device drive", comment: "")
            case .resourceNotFound(let key):
                return NSLocalizedString("The resource could not be found on the device drive. (key: \(key))", comment: "")
            case .cantWrite(let writeError):
                return NSLocalizedString("Can not write to device storage. Storage error: \(writeError.localizedDescription)", comment: "")
            case .releasedSelf:
                return NSLocalizedString("Self has been released.", comment: "")
        }
    }
}
