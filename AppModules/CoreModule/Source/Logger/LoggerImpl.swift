//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import os

typealias LoggerApi = os.Logger

public final class LoggerImpl: Logger {

    private let loggerApi: LoggerApi

    public init(category: String) {
        loggerApi = LoggerApi(subsystem: "General", category: category)
    }

    public func log(_ message: String, _ level: OSLogType) {
        loggerApi.log(level: level, "\(message)")
    }
}
