//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

public final class LoggerImpl: Logger {

    private let isLoggingEnabled: Bool

    public init(isLoggingEnabled: Bool) {
        self.isLoggingEnabled = isLoggingEnabled
    }

    public func log(message: String) {
        guard isLoggingEnabled else { return }

        print("\n******************\n\(message)\n******************\n")
    }

    public func log(error: Error) {
        guard isLoggingEnabled else { return }

        print("\n!*!*!*!*!*!*!*!*!*!\nError happened during the app execution:")
        print(error)
        print("!*!*!*!*!*!*!*!*!*!\n")
    }
}
