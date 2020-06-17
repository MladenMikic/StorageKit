//
//  Errors.swift
//  LocalDataStorage
//
//  Created by Mladen Mikic on 06/03/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case notFound
    case cantWrite(Error)
}
