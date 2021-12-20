//
//  HttpRequestCounterStub.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

class HttpRequestCounterStub: HttpRequestCounter {

    func increment() { }

    func decrement() { }

    var areRequestsPending: Bool = false
}
