//
//  LoggerImpl.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 24.03.2023.
//

import os

public final class LoggerImpl: CoreModule.Logger {

    private let logger: os.Logger

    public init(category: String) {
        logger = os.Logger(subsystem: "General", category: category)
    }

    public func log(_ message: String, level: LogLevel) {
        logger.log(level: level.getOsLogLevel(), "\(message)")
    }
}

extension LogLevel {

    func getOsLogLevel() -> OSLogType {
        switch self {
        case .debug:
            return .debug
            
        case .info:
            return .info
            
        case .default:
            return .default
            
        case .warn:
            return .error
            
        case .error:
            return .fault
        }
    }
}
