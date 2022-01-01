//
//  LoggerStub.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

import CoreModule
@testable import TodoList

class LoggerStub: Logger {

    func networkRequestStart(_ type: String) {
    }

    func networkRequestSuccess(_ type: String) {
    }

    func log(error: Error) {
    }
}
