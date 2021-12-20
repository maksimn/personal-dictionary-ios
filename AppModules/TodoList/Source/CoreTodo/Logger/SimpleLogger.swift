//
//  SimpleLogger.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 19.06.2021.
//

class SimpleLogger: Logger {

    public init() {
    }

    public func networkRequestStart(_ type: String) {
        print("\n\n\(type) NETWORK REQUEST START\n\n")
    }

    public func networkRequestSuccess(_ type: String) {
        print("\n\n\(type) NETWORK REQUEST SUCCESS\n\n")
    }

    public func log(error: Error) {
        print("\n\nError happened during the app execution:\n\(error)\n\n")
    }
}
