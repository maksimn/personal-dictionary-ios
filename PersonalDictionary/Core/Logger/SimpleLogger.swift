//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

final class SimpleLogger: Logger {

    private let isLoggingEnabled: Bool

    init(isLoggingEnabled: Bool) {
        self.isLoggingEnabled = isLoggingEnabled
    }

    func networkRequestStart(_ requestName: String) {
        guard isLoggingEnabled else { return }

        print("\n\(requestName) NETWORK REQUEST START\n")
    }

    func networkRequestSuccess(_ requestName: String) {
        guard isLoggingEnabled else { return }

        print("\n\(requestName) NETWORK REQUEST SUCCESS\n")
    }

    func networkRequestError(_ requestName: String) {
        guard isLoggingEnabled else { return }

        print("\n\(requestName) NETWORK REQUEST ERROR\n")
    }

    func log(error: Error) {
        guard isLoggingEnabled else { return }

        print("\nError happened during the app execution:")
        print(error)
    }
}
