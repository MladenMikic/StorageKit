//
//  CodableFileStorageConfiguration.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 06/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

public struct CodableFileStorageConfiguration: CodableFileStorageProtocol {
    public var storage: FileStorage
    
    public var decoder: JSONDecoder
    
    public var encoder: JSONEncoder
    
    public init(storage: FileStorage, decoder: JSONDecoder, encoder: JSONEncoder) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }
}
