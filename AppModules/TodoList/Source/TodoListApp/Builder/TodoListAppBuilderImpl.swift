//
//  TodoListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

public final class TodoListAppBuilderImpl: TodoListAppBuilder {

    public init() { }

    public func build() -> TodoListApp {
        TodoListAppImpl()
    }
}
