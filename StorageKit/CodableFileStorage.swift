//
//  BXDataStore.swift
//  BXAccounts
//
//  Created by Mladen Mikić on 20/02/2020.
//

import Foundation

public class FileStorageContainer {
    
    public let identifier: String
    public let storage: CodableFileStorage
    private let configuration: CodableFileStorageConfiguration
    
    init(identifier: String, storage: CodableFileStorage, configuration: CodableFileStorageConfiguration) {
        self.identifier = identifier
        self.storage = storage
        self.configuration = configuration
    }
}

public class CodableFileStorage {
    
    private let storage: FileStorage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        storage: FileStorage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.load(for: key)
        return try decoder.decode(T.self, from: data)
    }
    
    func fetch<T: Decodable>(for key: String, handler: @escaping Handler<T>) {
        
        self.storage.queue.async { [weak self] in
            do {
                if let eSelf = self,
                    let data = try self?.storage.load(for: key)
                {
                    let result = try eSelf.decoder.decode(T.self, from: data)
                    handler(.success(result))
                }
                else
                {
                    handler(.failure(StorageError.notFound))
                }
                
            } catch {
                handler(.failure(StorageError.notFound))
            }
            
        }
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
    
    func save<T: Encodable>(_ value: T, for key: String, handler: @escaping Handler<T>) {
        self.storage.queue.async { [weak self] in
            do {
                if let _ = try self?.encoder.encode(value) {
                    handler(.success(value))
                } else {
                    handler(.failure(StorageError.notFound))
                }
            } catch {
                handler(.failure(error))
            }
        }
    }

}
