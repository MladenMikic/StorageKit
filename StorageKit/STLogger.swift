//
//  STLogger.swift
//  StorageKit
//
//  Created by Mladen Mikic on 12.11.2021.
//  Copyright © 2021 Mladen Mikic. All rights reserved.
//

import Foundation


final internal class STLogger {
    
    static let shared = STLogger()
    
    init() {
        Storage.allowsLogging = false
        FileStorage.allowsLogging = false
        CodableFileStorage.allowsLogging = false
    }
}

protocol STLoggerProtocol {
    static var allowsLogging: Bool { get }
    func log(message: String)
}

extension STLoggerProtocol {
    // Lazy dependency injection.
    func log(message: String) {
        guard Self.allowsLogging else { return }
        STLogger.shared.log(message: message)
    }
}


extension STLogger: STLoggerProtocol {
    
    static var allowsLogging: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    func log(message: String) {
        guard Self.allowsLogging else { return }
        print("\t*StorageKit*: \(message)")
    }
}
