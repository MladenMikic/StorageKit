//
//  StorageProtocol.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 06/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

public typealias Handler<T> = (Result<T, Error>) -> Void
public typealias FailableResultHandler = (Error?) -> Void
public typealias ItemHandler = (URL?) -> Void

public protocol ReadableStorage {
    func load(for key: String) throws -> Data
    func load(for key: String, handler: @escaping Handler<Data>)
}

public protocol WritableStorage {
    func save(value: Data, for key: String) throws
    func save(value: Data, for key: String, handler: @escaping Handler<Data>)
}

typealias IOStorage = ReadableStorage & WritableStorage
