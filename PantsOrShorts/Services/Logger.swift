//
//  Logger.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public enum LogLevel {
    case info
    case debug
    case warn
    case error
}

public class Logger {
    public static let shared = Logger() // Shared instance
    
    private init() {
        // Singleton
    }
    
    public func log(_ level: LogLevel, anything: Any) {
        switch level {
        case .info:
            print("INFO: \(anything)")
        case .debug:
            debugPrint(anything)
        case .warn:
            print("WARNING: \(anything)")
        case .error:
            print("ERROR: \(anything)")
        }
    }
}
