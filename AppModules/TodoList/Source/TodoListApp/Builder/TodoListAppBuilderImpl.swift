//
//  TodoListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

public final class TodoListAppBuilderImpl: TodoListAppBuilder {

    private let routingButtonTitle: String

    public init(routingButtonTitle: String) {
        self.routingButtonTitle = routingButtonTitle
    }

    public func build() -> TodoListApp {
        TodoListAppImpl(routingButtonTitle: routingButtonTitle)
    }
}
