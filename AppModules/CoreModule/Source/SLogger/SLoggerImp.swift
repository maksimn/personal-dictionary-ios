//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import os

public final class SLoggerImp: SLogger {

    private let logger: Logger

    public init(category: String) {
        logger = Logger(subsystem: "General", category: category)
    }

    public func log(_ message: String) {
        logger.log(level: .debug, "\(message)")
    }
}
