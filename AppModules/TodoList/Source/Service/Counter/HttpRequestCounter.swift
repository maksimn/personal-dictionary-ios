//
//  HttpRequestCounter.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 13.07.2021.
//

protocol HttpRequestCounter {

    func increment()

    func decrement()

    var areRequestsPending: Bool { get }
}
