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
    
    public init(identifier: String, storage: CodableFileStorage, configuration: CodableFileStorageConfiguration) {
        self.identifier = identifier
        self.storage = storage
        self.configuration = configuration
    }
}

public class CodableFileStorage: STLoggerProtocol {
    
    // MARK: - STLoggerProtocol.
    static var allowsLogging: Bool = true
    
    private let storage: FileStorage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // MARK: - Init.

    public init(
        storage: FileStorage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }
    
    // MARK: - Fetch.

    public func fetch<T: Decodable>(for key: String) throws -> T {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        let data = try storage.load(for: key)
        return try decoder.decode(T.self, from: data)
    }
    
    public func fetchData(for key: String) throws -> Data {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        let data = try storage.load(for: key)
        return data
    }
    
    public func fetch<T: Decodable>(for key: String, handler: @escaping Handler<T>) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        self.storage.queue.async { [weak self] in
            do {
                if let eSelf = self,
                    let data = try self?.storage.load(for: key)
                {
                    self?.log(message: "\(String(describing: self)) :\(#function) Started fetching data.")
                    let result = try eSelf.decoder.decode(T.self, from: data)
                    self?.log(message: "\(String(describing: self)) :\(#function) Finished fetching data.")
                    handler(.success(result))
                }
                else
                {
                    self?.log(message: "\(String(describing: self)) :\(#function) Failed fetching data.")
                    handler(.failure(StorageError.resourceNotFound(forKey: key)))
                }
                
            } catch let error {
                self?.log(message: "\(String(describing: self)) :\(#function) Failed fetching data with error: \(error)")
                handler(.failure(StorageError.resourceNotFound(forKey: key)))
            }
            
        }
    }
    
    public func fetchItem(for key: String) -> URL { self.storage.loadItem(for: key) }
    
    public func fetchItem(for key: String, handler: @escaping ItemHandler) {
        
        self.storage.queue.async { [weak self] in
            self?.storage.load(for: key, handler: handler)
        }
    }
    
    // MARK: - Save.

    public func save<T: Encodable>(_ value: T, for key: String) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        do {
            if let dataValue = value as? Data {
                self.log(message: "\(self) :\(#function) Started saving data.")
                try storage.save(value: dataValue, for: key)
                self.log(message: "\(self) :\(#function) Saved data.")
            } else {
                self.log(message: "\(self) :\(#function) Started encoding value to data.")
                let data = try encoder.encode(value)
                self.log(message: "\(self) :\(#function) Finished encoding data.")
                self.log(message: "\(self) :\(#function) Started storing data.")
                try storage.save(value: data, for: key)
                self.log(message: "\(self) :\(#function) Finished storing data.")
            }
        } catch let error {
            self.log(message: "\(self) :\(#function) Failed with error: \(error).")
        }
        
    }
    
    public func save<T: Encodable>(_ value: T, for key: String, handler: @escaping Handler<T>) {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        self.storage.queue.async { [weak self] in
            
            guard let strongSelf = self else { return handler(.failure(StorageError.releasedSelf)) }
            
            do {
                let data = try strongSelf.encoder.encode(value)
                strongSelf.log(message: "\(strongSelf) :\(#function) Started storing data.")
                try strongSelf.storage.save(value: data, for: key)
                strongSelf.log(message: "\(strongSelf) :\(#function) Data stored.")
                handler(.success(value))
            } catch let error {
                strongSelf.log(message: "\(strongSelf) :\(#function) Failed with error: \(error).")
                handler(.failure(error))
            }
        }
    }
    
    public func saveItem(from sourceURL: URL, for key: String) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        do {
            try self.storage.saveItem(from: sourceURL, for: key)
        } catch let error {
            self.log(message:"\(self): \(#function): error: \(error)")
            throw error
        }
    }
    
    public func saveItem(from sourceURL: URL, for key: String, handler: @escaping FailableResultHandler) {
        
        self.storage.queue.async { [weak self] in
            
            guard let strongSelf = self else { return handler(StorageError.releasedSelf) }
            
            strongSelf.log(message: "\(strongSelf) :\(#function) Started copying item.")
            strongSelf.storage.saveItem(from: sourceURL, for: key, handler: handler)
            strongSelf.log(message: "\(strongSelf) :\(#function) Finished copying item.")
        }
        
    }
    
    // MARK: - Remove.
    
    public func removeItem(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    public func removeItem(for key: String) throws {
        
        self.log(message: "\(self) :\(#function) :\(#line)")
        
        do {
            try self.storage.removeItem(for: key)
        } catch let error {
            self.log(message:"\(self): \(#function): error: \(error)")
            throw error
        }
        
     
    }
    
    public func fileExists(atPath: String) -> Bool { FileManager.default.fileExists(atPath: atPath) }
}
