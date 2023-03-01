//
//  Logger.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/3/1.
//

import Foundation

class Logger {

    static func log<T>(method: String = #function, message: T) {
        #if DEBUG
        NSLog("[will - ✅ Method: \(method), Message: \(message)]")
        #endif
    }

    static func errorLog<T>(method: String = #function, message: T) {
        #if DEBUG
        NSLog("[will - ❌ Method: \(method), errorMessage: \(message)]")
        #endif
    }
}
