//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

final class SimpleLogger: Logger {

    func log(error: Error) {
        print("\n\nError happened during the app execution:")
        print(error)
    }
}
