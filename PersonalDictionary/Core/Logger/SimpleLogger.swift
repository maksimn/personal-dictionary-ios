//
//  SimpleLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

final class SimpleLogger: Logger {

    func networkRequestStart(_ requestName: String) {
        print("\n\n\(requestName) NETWORK REQUEST START\n\n")
    }

    func networkRequestSuccess(_ requestName: String) {
        print("\n\n\(requestName) NETWORK REQUEST SUCCESS\n\n")
    }

    func networkRequestError(_ requestName: String) {
        print("\n\n\(requestName) NETWORK REQUEST ERROR\n\n")
    }

    func log(error: Error) {
        print("\n\nError happened during the app execution:")
        print(error)
    }
}
