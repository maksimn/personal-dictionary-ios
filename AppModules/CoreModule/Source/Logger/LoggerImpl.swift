//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import os

typealias LoggerApi = os.Logger

public final class LoggerImpl: Logger {

    private let isLoggingEnabled: Bool
    private let loggerApi: LoggerApi

    public init(
        isLoggingEnabled: Bool,
        category: String
    ) {
        self.isLoggingEnabled = isLoggingEnabled
        loggerApi = LoggerApi(subsystem: "General", category: category)
    }

    public func log(_ message: String, _ level: OSLogType) {
        guard isLoggingEnabled else { return }

        loggerApi.log(level: level, "\(message)")
    }
}
