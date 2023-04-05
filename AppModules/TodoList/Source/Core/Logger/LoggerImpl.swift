//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

final class LoggerImpl: Logger {

    func log(message: String) {
        print("\n******************\n\(message)")
    }

    func log(error: Error) {
        print("\n!*!*!*!*!*!*!*!*!*!\nError happened during the app execution:")
        print(error)
    }
}
