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
        
        guard let data = fileManager.contents(atPath: url.path) else { throw StorageError.notFound }
        
        return data
    }

    public func load(for key: String, handler: @escaping Handler<Data>) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        queue.async {
            handler(Result { try self.load(for: key) })
        }
    }
}
