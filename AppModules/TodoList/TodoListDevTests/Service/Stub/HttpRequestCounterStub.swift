//
//  HttpRequestCounterStub.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

class HttpRequestCounterPublisherStub: HttpRequestCounterPublisher {
    func increment() { }

    func decrement() { }
}

