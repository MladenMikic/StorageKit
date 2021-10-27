//
//  FileStorage.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 06/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

public class FileStorage {
    internal let queue: DispatchQueue
    private let fileManager: FileManager
    private let path: URL

    public init(
        path: URL,
        queue: DispatchQueue = .init(label: "DiskCache.Queue"),
        fileManager: FileManager = .default
    ) {
        self.path = path
        self.queue = queue
        self.fileManager = fileManager
    }
    
    public static func withUserDirectory() throws -> FileStorage {
        do
        {
            let userDocumentsDirectoryURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return FileStorage(path: userDocumentsDirectoryURL)
        } catch let error {
            throw error
        }
    }
}


extension FileStorage: WritableStorage {
    public func save(value: Data, for key: String) throws {
        let url = path.appendingPathComponent(key)
        do {
            try self.createFolder(in: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }

    public func save(value: Data, for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            do {
                try self.save(value: value, for: key)
                handler(.success(value))
            } catch {
                handler(.failure(error))
            }
        }
    }
}

extension FileStorage {
    private func createFolder(in url: URL) throws {
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
        let url = path.appendingPathComponent(key)
        guard let data = fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }

    public func load(for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            handler(Result { try self.load(for: key) })
        }
    }
}
