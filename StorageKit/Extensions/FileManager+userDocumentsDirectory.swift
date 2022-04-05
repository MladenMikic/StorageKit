//
//  FileManager+removeContentsOfTemporaryDirectory.swift
//  StorageKit
//
//  Created by Mladen Mikic on 08.12.2021.
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import Foundation

public extension FileManager {
    /// for: .documentDirectory
    /// in: .userDomainMask
    static var documentsDirectory: URL? { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first }
    
    /// Perform this method on a background thread.
    /// Returns `true` if :
    ///     * all temporary folder files have been deleted.
    ///     * the temporary folder is empty.
    /// Returns `false` if :
    ///     * some temporary folder files have not been deleted.
    /// Error handling:
    ///     * Throws `contentsOfDirectory` directory access error.
    ///     * Ignores single file `removeItem` errors.
    ///
    @discardableResult
    func removeContentsOfTemporaryDirectory() throws -> Bool  {
        
        if Thread.isMainThread {
            let mainThreadWarningMessage = "\(#file) - \(#function) executed on main thread. Do not block the main thread."
            assertionFailure(mainThreadWarningMessage)
        }
        
        do {
            
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectoryContent = try contentsOfDirectory(atPath: tmpDirURL.path)
            
            guard tmpDirectoryContent.count != 0 else { return true }
            
            for tmpFilePath in tmpDirectoryContent {
                let trashFileURL = tmpDirURL.appendingPathComponent(tmpFilePath)
                try removeItem(atPath: trashFileURL.path)
            }
            
            let tmpDirectoryContentAfterDeletion = try contentsOfDirectory(atPath: tmpDirURL.path)
            
            return tmpDirectoryContentAfterDeletion.count == 0
            
        } catch let directoryAccessError {
            throw directoryAccessError
        }
        
    }
}
