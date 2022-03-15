//
//  FileStorage.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 06/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

public class FileStorage: STLoggerProtocol {
    
    // MARK: - STLoggerProtocol.
    static var allowsLogging: Bool = true
    
    internal let queue: DispatchQueue
    private let fileManager: FileManager
    private let path: URL
    
    // MARK: - Init.

    public init(
        path: URL,
        queue: DispatchQueue = .init(label: "DiskCache.Queue.\(Int.random(in: 0...Int.max))"),
        fileManager: FileManager = .default
    ) {
        self.path = path
        self.queue = queue
        self.fileManager = fileManager
    }
    
    public static func withUserDirectory() throws -> FileStorage {
        do
        {
            let userDocumentsDirectoryURL = try FileManager.default.url(for: .documentDirectory,
                                                                           in: .userDomainMask,
                                                                           appropriateFor: nil,
                                                                           create: true)
            return FileStorage(path: userDocumentsDirectoryURL)
        } catch let error {
            STLogger.shared.log(message: "FileStorage failed to create user directory with error: \(error)")
            throw error
        }
    }
}


extension FileStorage: WritableStorage {
    
    public func save(value: Data, for key: String) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        self.log(message: "value :\(value) key:\(key)")
        
        let url = path.appendingPathComponent(key)
        do {
            try self.createFolder(in: url)
            self.log(message: "\(self) :\(#function) Started writting to disk.")
            try value.write(to: url, options: .atomic)
            self.log(message: "\(self) :\(#function) Finished writting to disk.")
        } catch let error {
            self.log(message: "\(self) :\(#function) Failed writting to disk with error: \(error).")
            throw StorageError.cantWrite(error)
        }
    }

    public func save(value: Data, for key: String, handler: @escaping Handler<Data>) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        queue.async {
            do {
                self.log(message: "\(self) :\(#function) Started writting to disk.")
                try self.save(value: value, for: key)
                self.log(message: "\(self) :\(#function) Finished writting to disk.")
                handler(.success(value))
            } catch let error {
                self.log(message: "\(self) :\(#function) Failed writting to disk with error: \(error).")
                handler(.failure(error))
            }
        }
    }
    
    public func saveItem(from sourceURL: URL, for key: String) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        self.log(message: "sourceURL :\(sourceURL) key:\(key)")
        
        let url = path.appendingPathComponent(key)
        do {
            try self.createFolder(in: url)
            self.log(message: "\(self) :\(#function) Started copying item to disk.")
            if FileManager.default.fileExists(atPath: url.path) {
                self.log(message: "\(self) :\(#function) File exists at path: \(url.path).")
                try FileManager.default.removeItem(at: url)
            }
            
            try FileManager.default.copyItem(at: sourceURL, to: url)

            self.log(message: "\(self) :\(#function) Finished copying to disk.")
        } catch let error {
            self.log(message: "\(self) :\(#function) Failed copying to disk with error: \(error).")
            throw StorageError.cantWrite(error)
        }
    }
    
    public func saveItem(from sourceURL: URL, for key: String, handler: @escaping FailableResultHandler) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        queue.async { [weak self] in
            
            guard let strongSelf = self else { return handler(StorageError.releasedSelf) }
            
            let url = strongSelf.path.appendingPathComponent(key)
            do {
                try strongSelf.createFolder(in: url)
                strongSelf.log(message: "\(strongSelf) :\(#function) Started copy item to disk.")
                if FileManager.default.fileExists(atPath: url.path) {
                    strongSelf.log(message: "\(strongSelf) :\(#function) File exists at path: \(url.path).")
                    try FileManager.default.removeItem(at: url)
                }
                try FileManager.default.copyItem(at: sourceURL, to: url)
                
                strongSelf.log(message: "\(strongSelf) :\(#function) Finished copying to disk.")
            } catch let error {
                strongSelf.log(message: "\(strongSelf) :\(#function) Failed copying to disk with error: \(error).")
                handler(StorageError.cantWrite(error))
            }
        }
    }
}

extension FileStorage {
    
    private func createFolder(in url: URL) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        let folderUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try fileManager.createDirectory(
                at: folderUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
}

extension FileStorage: ReadableStorage {
    
    public func load(for key: String) throws -> Data {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        let url = path.appendingPathComponent(key)
        
        guard let data = fileManager.contents(atPath: url.path) else { throw StorageError.resourceNotFound(forKey: key) }
        
        return data
    }

    public func load(for key: String, handler: @escaping Handler<Data>) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        queue.async {
            handler(Result { try self.load(for: key) })
        }
    }
    
    /// Returns the URL where the item is stored.
    public func loadItem(for key: String) -> URL {
        self.log(message: "\(self) :\(#function) :\(#line)")
        return path.appendingPathComponent(key)
    }
    
    public func load(for key: String, handler: @escaping ItemHandler) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        queue.async { [weak self] in
            handler(self?.path.appendingPathComponent(key))
        }
    }
    
}

extension FileStorage {
    
    public func removeItem(for key: String) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        let url = self.path.appendingPathComponent(key)
        
        do {
            try FileManager.default.removeItem(at: url)
            self.log(message: "\(self) :\(#function) removed item for key: \(key) in: \(url)")
        } catch let error {
            self.log(message: "\(self) :\(#function) Failed removing item for key: \(key) with error: \(error).")
            throw error
        }
        
    }
    
}
