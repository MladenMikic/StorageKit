//
//  CodableFileStorageProtocol.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 04/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

public protocol CodableFileStorageProtocol
{
    var storage: FileStorage { set get }
    var decoder: JSONDecoder { set get }
    var encoder: JSONEncoder { set get }
    init(storage: FileStorage,
        decoder: JSONDecoder,
        encoder: JSONEncoder)
}

