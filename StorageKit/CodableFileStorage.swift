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

    public init(
        storage: FileStorage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

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
                    handler(.failure(StorageError.notFound))
                }
                
            } catch let error {
                self?.log(message: "\(String(describing: self)) :\(#function) Failed fetching data with error: \(error)")
                handler(.failure(StorageError.notFound))
            }
            
        }
    }

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
            do {
                self?.log(message: "\(String(describing: self)) :\(#function) Started storing data.")
                if let _ = try self?.encoder.encode(value) {
                    self?.log(message: "\(String(describing: self)) :\(#function) Started storing data.")
                    handler(.success(value))
                } else {
                    handler(.failure(StorageError.notFound))
                }
            } catch let error {
                self?.log(message: "\(String(describing: self)) :\(#function) Failed with error: \(error).")
                handler(.failure(error))
            }
        }
    }

}
