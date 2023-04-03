//
//  LoggerImpl.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 24.03.2023.
//

import os

public final class LoggerImpl: CoreModule.Logger {

    private let category: String

    private var _logger: Any?

    @available(iOS 14.0, *)
    private var logger: os.Logger {
        if _logger == nil {
            _logger = os.Logger(subsystem: "General", category: category)
        }

        return _logger as! os.Logger
    }

    public init(category: String) {
        self.category = category
    }

    public func log(_ message: String, level: LogLevel) {
        guard isDevelopment() else { return }

        if #available(iOS 14, *) {
            logger.log(level: level.getOsLogLevel(), "[\(level.rawValue)] \(message)")
        } else {
            print("[\(category)] [\(level.rawValue)] \(message)")
        }
    }
}

extension LogLevel {

    func getOsLogLevel() -> OSLogType {
        switch self {
        case .debug:
            return .debug
            
        case .info:
            return .default
            
        case .warn:
            return .error
            
        case .error:
            return .fault
        }
    }
}
